# CLAUDE.md

This file gives Claude Code guidance for working in this repository.

## Project

CineTrack is an iOS SwiftUI app for browsing movies from TMDB (The Movie Database). Users can mark movies as to-watch or watched, favorite them, rate and review them, and see statistics about what they've watched. Data is stored locally with SwiftData. There are no third-party dependencies (no SPM, CocoaPods or Carthage).

- Deployment target: iOS 26.5, Swift 5 language mode
- Build settings: `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and `SWIFT_APPROACHABLE_CONCURRENCY = YES`. Types are MainActor-isolated by default; mark code `nonisolated` or put it in an `actor` when it must run off the main actor (see `ImageCache`).
- The Xcode project uses **file-system synchronized groups**, so new `.swift` files placed under `CineTrack/`, `CineTrackTests/` or `CineTrackUITests/` are picked up automatically. Do not edit `project.pbxproj` to add files.

## Building and testing

**Do not run `xcodebuild`.** The user builds and runs tests in Xcode themselves. After making changes, say what should be built or tested.

- Shared scheme: `CineTrack` (in `CineTrack.xcodeproj/xcshareddata/xcschemes/`)
- Unit tests use **Swift Testing** (`import Testing`, `@Suite`, `@Test`, `#expect`), not XCTest. Tests that touch view models or SwiftData are marked `@MainActor`.
- SwiftData tests use an in-memory container: `ModelContainer(for: WatchlistMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))`, with `container.mainContext` passed into the repository.

## Secrets / API key

`APIKey.tmdbToken` ([CineTrack/Core/Network/APIKey.swift](CineTrack/Core/Network/APIKey.swift)) reads `TMDB_API_KEY` (a TMDB v4 bearer token) from `CineTrack/Resources/Config.plist` and calls `fatalError` if it is missing. `APIKey.swift` holds no secret and is tracked. `Config.plist` is gitignored; never commit it or print its contents. A fresh clone copies the template first: `cp Config.example.plist CineTrack/Resources/Config.plist` and fills in the token. The template lives at the repo root so it isn't bundled into the app.

Note that `Config.plist` is copied into the app bundle in plain text, so the token can be extracted from a shipped build. Moving it behind a server-side proxy is the planned fix before App Store release.

## Architecture

MVVM + protocol-based services + a simple DI container, organized by feature.

```
CineTrack/
  App/                 CineTrackApp: @main, sets up the SwiftData modelContainer
  Core/
    DependencyInjection/DIContainer.swift   singleton; lazy services + make…ViewModel() factories
    Network/           Endpoint protocol, TMDBEndpoint enum, NetworkService (generic async request), APIError
    Persistence/       SwiftData @Model types + repositories (protocol + implementation)
    ImageCache/        actor ImageCache (NSCache), ImageLoader, CachedAsyncImage view
    Extensions/        display/formatting helpers (Movie+URL, Movie+Display, String+Date, …)
  Models/              shared API models (Movie, TrendingMoviesResponse)
  Features/
    Main/              MainTabView: Home, Search, Tonight (center), Watchlist, Statistics tabs
    Home/ Search/ MovieDetail/ Watchlist/ Statistics/ Tonight/
      Services/ ViewModels/ Views/ Views/Components/ (Models/ where needed)
  Resources/           Config.plist, shared components (ImagePlaceholderView)
```

### Networking

- Add new API calls as a case on `TMDBEndpoint` (path + query items). Every request sends `language=tr-TR`.
- `NetworkService.request(endpoint:responseModel:)` builds the URL against `https://api.themoviedb.org`, adds the bearer header, checks for a 2xx status and decodes the response. Errors are mapped to `APIError` (`invalidURL`, `invalidResponse`, `statusCode`, `decodingError`, `noInternet`, `unknown`).
- Each feature has a `…ServiceProtocol` and a `…Service` that wrap `NetworkServiceProtocol`. Image URLs are built in `Movie+URL.swift` (`image.tmdb.org/t/p/w500` for posters, `w780` for backdrops).

### View models

- `@MainActor @Observable final class`. State is `private(set)` where the view doesn't write to it. `isLoading` and `errorMessage` follow the same pattern across view models.
- Independent fetches run in parallel with `async let` (see `HomeViewModel`, `MovieDetailViewModel.loadMovie`).
- Views hold their view model as `@State private var viewModel = DIContainer.shared.make…ViewModel()`. `StatisticsViewModel` is created directly and loaded with `load(context:)`.
- `SearchViewModel` debounces input by 500 ms with a cancellable `Task` and paginates through `currentPage` / `totalPages`.

### Persistence (SwiftData)

Models are registered in `CineTrackApp.modelContainer(for: [WatchlistMovie.self, PersonalMovieRating.self])`. A new `@Model` must be added to that list and to any test containers that need it.

- `WatchlistMovie` (unique `id` = TMDB id) is the user's library entry. `watchStatus` is stored as a raw `String?` from `MovieWatchStatus` (`planned` / `watched`); `isFavorite` is stored separately. It also keeps `genreNames`, `runtime` and `directorName` for statistics. New stored properties need default values so existing stores migrate without problems.
- `WatchlistRepository` handles status and favorites with find-or-create; `deleteIfUnused` removes an entry once it has no status and isn't a favorite. Setting the status that is already set clears it (toggle behavior in `MovieDetailViewModel.setWatchStatus`).
- `PersonalMovieRating` (unique `movieID`) holds a 1–5 rating and an optional review, accessed through `PersonalMovieRatingRepository`, whose methods throw.
- Repositories need a `ModelContext`, which only exists in the view environment. Views read `@Environment(\.modelContext)` and inject the repositories in `.task` through `viewModel.configure(…)` (see `MovieDetailView`). That's why repositories are optional properties on the view model. `MyLibraryView` uses `@Query` directly.
- `#Predicate` cannot reference enum cases directly. Copy the raw value into a local constant first (`let raw = MovieWatchStatus.watched.rawValue`).

### Tonight

`TonightViewModel` suggests a random movie from TMDB `/3/discover/movie`: it fetches page 1 to learn `total_pages` (capped at 500), then tries up to 3 random pages, skipping watched movies, movies already shown this session and movies without a poster. `DiscoverFilters` (genres OR'ed with `|`, year range, min rating, max runtime, original language) builds the query items and always adds a hidden `vote_count.gte=200` baseline; filters are persisted in UserDefaults via `TonightFilterStoreProtocol`. The suggested movie's detail + credits are loaded so library actions can go through `WatchlistRepository`.

### Statistics

`StatisticsViewModel` reads watched `WatchlistMovie`s and all `PersonalMovieRating`s to compute totals, watch time, average rating, and rating/genre/director distributions (top `topDirectorLimit` = 5 directors). The charts in `Statistics/Views/Components` use Swift Charts.

## Tests

`CineTrackTests/` has tests for `HomeViewModel`, `SearchViewModel`, `MovieDetailViewModel`, `StatisticsViewModel`, `WatchlistRepository`, `ImageCache`, `TonightViewModel` and `DiscoverFilters`. Hand-written mocks live in `CineTrackTests/Mocks/` (`MockMovieService`, `MockMovieDetailService`, `MockWatchlistRepository`, `MockTonightService`, `MockTonightFilterStore`, …). When a service or repository protocol changes, update its mock as well.

## Conventions

- UI strings are in English. Some code comments are in Turkish.
- One type per file, with the standard Xcode header comment.
- Full-screen states use the shared `LoadingStateView` and `ErrorStateView` (with an async `onRetry`) from `Resources/Components`; empty states use `ContentUnavailableView`. View models reset `errorMessage` when a load starts and skip cancelled requests (`error.isCancellation`).
- Keep view subcomponents in `Views/Components/` of their feature. Reusable display logic goes in `Core/Extensions` as `+Display` extensions.
