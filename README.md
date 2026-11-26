![Swift](https://img.shields.io/badge/Swift-5_mode-orange)
![Platform](https://img.shields.io/badge/iOS-26.5+-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-green)
![Architecture](https://img.shields.io/badge/MVVM-Repository-red)

# 🎬 CineTrack

A modern movie discovery and tracking app built with **SwiftUI** using **MVVM**, **Repository Pattern**, **Dependency Injection**, and **SwiftData**.

Browse trending, popular, and top-rated movies, search instantly, watch trailers, and explore cast and directors. Keep track of what you want to watch and what you've watched, rate and review movies, get a random pick for tonight, and see statistics about your viewing habits.

---

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/17e2d2c9-b4c1-4056-bfe4-bf80a4169531" width="24%" />
  <img src="https://github.com/user-attachments/assets/d350a481-b41c-4228-b94c-b92ff266d6d4" width="24%" />
  <img src="https://github.com/user-attachments/assets/f934b852-4b25-4c50-b4ba-03d9836e34de" width="24%" />
  <img src="https://github.com/user-attachments/assets/771fa027-5da7-4f9c-9bc8-f4ce8c4c4f6d" width="24%" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e3f7c81b-ce5c-4433-ac93-3a789d2d6681" width="24%" alt="My Library" />
  <img src="https://github.com/user-attachments/assets/fd35e454-708a-4761-81d7-9ce0ccbf8c48" width="24%" alt="Tonight" />
  <img src="https://github.com/user-attachments/assets/89cf1dae-2d20-45f3-863c-b7547911ad15" width="24%" alt="Statistics" />
  <img src="https://github.com/user-attachments/assets/84fc7396-3b0a-41ce-a378-ccf54f649017" width="24%" alt="Person Detail" />
</p>


---

## ✨ Features

### Discover
- 🎬 Trending, Popular and Top Rated movies
- 🔍 Real-time movie search with debounce and pagination
- 📄 Detailed movie information with genres, director and runtime
- ▶️ Watch official trailers
- 🎞 Similar movie recommendations

### People
- 👥 Cast list on every movie
- 🎭 Person detail pages for actors and directors: biography and filmography
- 🌐 Falls back to the English biography when no Turkish one is available

### My Library
- 🔖 Mark movies as **To Watch** or **Watched**
- ❤️ Favorite movies, independently of their watch status
- 🗂 Library with To Watch / Watched / Favorites tabs
- 🏷 Status and favorite badges on movie posters
- ⭐ Personal 1–5 star rating with an optional written review

### Tonight 🍿
- 🎲 Get a random movie suggestion for tonight
- 🎛 Filter by genres, release year range, minimum rating, maximum runtime and original language
- ✅ Skips movies you've already watched and movies already suggested this session
- 💾 Filters are remembered between launches

### Statistics 📊
- Total watched movies and total watch time
- Average personal rating
- Rating, genre and top director distributions with Swift Charts

### General
- ✨ Animated launch screen and light / dark / tinted app icons
- 🖼 Image caching
- 💾 Local persistence with SwiftData
- ⚡ Built with Swift Concurrency (async/await)
- 🧪 Unit & UI Tests

---

## 🏛 Architecture

```
SwiftUI
    │
    ▼
View
    │
    ▼
ViewModel
    │
    ▼
Repository / Service
    │
    ▼
SwiftData / Network Layer
    │
    ▼
TMDB API
```

### Patterns

- MVVM
- Repository Pattern
- Dependency Injection
- Protocol-Oriented Programming

---

## 🛠 Technologies

- Swift (Swift 5 language mode, MainActor isolation by default)
- SwiftUI
- Swift Concurrency
- Swift Charts
- URLSession
- SwiftData
- TMDB API
- XCTest & Swift Testing
- No third-party dependencies

---

## 📂 Project Structure

```
CineTrack/
  App/            App entry point and SwiftData container
  Core/           DI container, networking, persistence, image cache, extensions
  Models/         Shared API models
  Features/
    Main/         Tab bar
    Launch/       Animated launch screen
    Home/
    Search/
    MovieDetail/
    PersonDetail/
    Watchlist/    My Library
    Tonight/
    Statistics/
  Resources/
CineTrackTests/
CineTrackUITests/
```

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/JiyanAtalay/CineTrack.git
cd CineTrack
```

Copy the config template and add your TMDB **v4 API Read Access Token**:

```bash
cp Config.example.plist CineTrack/Resources/Config.plist
```

Then replace `YOUR_TMDB_V4_READ_ACCESS_TOKEN` in `Config.plist` with your token. `Config.plist` is gitignored, so it won't be committed.

You can get a free token from https://www.themoviedb.org/settings/api

Run the project using **Xcode 26+** (iOS 26.5 SDK).

---

## 🧪 Testing

The project includes Unit Tests (Swift Testing) and UI Tests.

Covered components include:

- HomeViewModel
- SearchViewModel
- MovieDetailViewModel
- PersonDetailViewModel
- TonightViewModel
- DiscoverFilters
- StatisticsViewModel
- WatchlistRepository
- ImageCache

---

## 📚 What I Learned

- Building scalable SwiftUI applications
- Repository Pattern
- Dependency Injection
- SwiftData (models, predicates, lightweight migration)
- Generic networking
- Image caching
- Async/Await and parallel requests with `async let`
- Debounced search
- Pagination
- Data visualization with Swift Charts
- Unit Testing
- UI Testing
- Clean Architecture

---

## 👨‍💻 Author
**Mehmet Jiyan Atalay** * LinkedIn: [Mehmet Jiyan Atalay](https://www.linkedin.com/in/jiyan-atalay-407360279/)
* GitHub: [@JiyanAtalay](https://github.com/JiyanAtalay)
