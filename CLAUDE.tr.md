# CLAUDE.md (Türkçe)

> Bu dosya [CLAUDE.md](CLAUDE.md) dosyasının Türkçe çevirisidir. Claude Code yalnızca `CLAUDE.md` dosyasını otomatik olarak okur; ikisini birlikte güncel tutun.

Bu dosya, Claude Code'un bu depoda nasıl çalışacağına dair yönergeler içerir.

## Proje

CineTrack, TMDB'den (The Movie Database) film göz atmak için geliştirilmiş bir iOS SwiftUI uygulamasıdır. Kullanıcılar filmleri izlenecek veya izlendi olarak işaretleyebilir, favorilere ekleyebilir, puanlayıp yorum yazabilir ve izledikleri filmlerle ilgili istatistikleri görebilir. Veriler SwiftData ile cihazda saklanır. Üçüncü taraf bağımlılık yoktur (SPM, CocoaPods veya Carthage kullanılmaz).

- Minimum iOS sürümü: iOS 26.5, Swift 5 dil modu
- Derleme ayarları: `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` ve `SWIFT_APPROACHABLE_CONCURRENCY = YES`. Tipler varsayılan olarak MainActor'a bağlıdır; ana aktör dışında çalışması gereken kodu `nonisolated` olarak işaretleyin veya bir `actor` içine koyun (bkz. `ImageCache`).
- Xcode projesi **dosya sistemiyle senkronize gruplar** kullanır; bu yüzden `CineTrack/`, `CineTrackTests/` veya `CineTrackUITests/` altına eklenen yeni `.swift` dosyaları otomatik olarak projeye dahil edilir. Dosya eklemek için `project.pbxproj` dosyasını düzenlemeyin.

## Derleme ve test

**`xcodebuild` çalıştırmayın.** Kullanıcı derlemeyi ve testleri Xcode'da kendisi yapar. Değişiklik yaptıktan sonra neyin derlenmesi veya test edilmesi gerektiğini belirtin.

- Paylaşılan şema: `CineTrack` (`CineTrack.xcodeproj/xcshareddata/xcschemes/` içinde)
- Birim testleri XCTest değil **Swift Testing** kullanır (`import Testing`, `@Suite`, `@Test`, `#expect`). View model'lere veya SwiftData'ya dokunan testler `@MainActor` ile işaretlenir.
- SwiftData testleri bellek içi bir container kullanır: `ModelContainer(for: WatchlistMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))`, ardından `container.mainContext` repository'ye verilir.

## Gizli bilgiler / API anahtarı

`APIKey.tmdbToken` ([CineTrack/Core/Network/APIKey.swift](CineTrack/Core/Network/APIKey.swift)), `TMDB_API_KEY` değerini (TMDB v4 bearer token) `CineTrack/Resources/Config.plist` dosyasından okur; değer yoksa `fatalError` çağırır. `APIKey.swift` sır içermez ve git'te takip edilir. `Config.plist` gitignore'dadır; asla commit etmeyin ve içeriğini yazdırmayın. Depoyu yeni klonlayan biri önce şablonu kopyalar: `cp Config.example.plist CineTrack/Resources/Config.plist` ve token'ı doldurur. Şablon, uygulama paketine girmemesi için depo kökünde durur.

`Config.plist` uygulama paketine düz metin olarak kopyalanır; yani yayınlanmış bir derlemeden token çıkarılabilir. App Store'a çıkmadan önce planlanan çözüm, token'ı sunucu tarafında bir proxy'nin arkasına taşımaktır.

## Mimari

MVVM + protokol tabanlı servisler + basit bir DI container; özelliklere (feature) göre düzenlenmiştir.

```
CineTrack/
  App/                 CineTrackApp: @main, SwiftData modelContainer'ını kurar
  Core/
    DependencyInjection/DIContainer.swift   singleton; lazy servisler + make…ViewModel() fabrikaları
    Network/           Endpoint protokolü, TMDBEndpoint enum'u, NetworkService (generic async istek), APIError
    Persistence/       SwiftData @Model tipleri + repository'ler (protokol + implementasyon)
    ImageCache/        actor ImageCache (NSCache), ImageLoader, CachedAsyncImage view'ı
    Extensions/        gösterim/biçimlendirme yardımcıları (Movie+URL, Movie+Display, String+Date, …)
  Models/              ortak API modelleri (Movie, TrendingMoviesResponse)
  Features/
    Main/              MainTabView: Home, Search, Tonight (ortada), Watchlist, Statistics sekmeleri
    Home/ Search/ MovieDetail/ Watchlist/ Statistics/ Tonight/
      Services/ ViewModels/ Views/ Views/Components/ (gerektiğinde Models/)
  Resources/           Config.plist, ortak bileşenler (ImagePlaceholderView)
```

### Ağ katmanı

- Yeni API çağrılarını `TMDBEndpoint` üzerinde yeni bir case olarak ekleyin (path + query item'lar). Her istek `language=tr-TR` gönderir.
- `NetworkService.request(endpoint:responseModel:)` URL'yi `https://api.themoviedb.org` üzerine kurar, bearer header'ını ekler, 2xx durum kodunu kontrol eder ve yanıtı decode eder. Hatalar `APIError`'a dönüştürülür (`invalidURL`, `invalidResponse`, `statusCode`, `decodingError`, `noInternet`, `unknown`).
- Her özelliğin `NetworkServiceProtocol`'ü saran bir `…ServiceProtocol` ve `…Service` tipi vardır. Görsel URL'leri `Movie+URL.swift` içinde oluşturulur (posterler için `image.tmdb.org/t/p/w500`, arka planlar için `w780`).

### View model'ler

- `@MainActor @Observable final class`. View'ın yazmadığı state `private(set)` olur. `isLoading` ve `errorMessage` tüm view model'lerde aynı kalıbı izler.
- Birbirinden bağımsız istekler `async let` ile paralel çalışır (bkz. `HomeViewModel`, `MovieDetailViewModel.loadMovie`).
- View'lar view model'i `@State private var viewModel = DIContainer.shared.make…ViewModel()` şeklinde tutar. `StatisticsViewModel` doğrudan oluşturulur ve `load(context:)` ile yüklenir.
- `SearchViewModel` girdiyi iptal edilebilir bir `Task` ile 500 ms debounce eder ve `currentPage` / `totalPages` üzerinden sayfalama yapar.

### Kalıcılık (SwiftData)

Modeller `CineTrackApp.modelContainer(for: [WatchlistMovie.self, PersonalMovieRating.self])` içinde kaydedilir. Yeni bir `@Model` bu listeye ve ona ihtiyaç duyan test container'larına eklenmelidir.

- `WatchlistMovie` (benzersiz `id` = TMDB id) kullanıcının kütüphane kaydıdır. `watchStatus`, `MovieWatchStatus`'tan (`planned` / `watched`) gelen ham `String?` değer olarak saklanır; `isFavorite` ayrı tutulur. İstatistikler için `genreNames`, `runtime` ve `directorName` da saklanır. Mevcut veritabanlarının sorunsuz taşınabilmesi için yeni stored property'lerin varsayılan değeri olmalıdır.
- `WatchlistRepository`, durum ve favorileri find-or-create mantığıyla yönetir; `deleteIfUnused`, durumu olmayan ve favori olmayan kaydı siler. Zaten seçili olan durumu tekrar seçmek onu temizler (`MovieDetailViewModel.setWatchStatus` içindeki aç/kapa davranışı).
- `PersonalMovieRating` (benzersiz `movieID`) 1–5 arası bir puan ve isteğe bağlı bir yorum tutar; metotları hata fırlatan (`throws`) `PersonalMovieRatingRepository` üzerinden erişilir.
- Repository'ler bir `ModelContext`'e ihtiyaç duyar ve bu yalnızca view ortamında bulunur. View'lar `@Environment(\.modelContext)` okur ve repository'leri `.task` içinde `viewModel.configure(…)` ile enjekte eder (bkz. `MovieDetailView`). Bu yüzden repository'ler view model'de optional property'dir. `MyLibraryView` doğrudan `@Query` kullanır.
- `#Predicate` enum case'lerine doğrudan başvuramaz. Önce ham değeri yerel bir sabite kopyalayın (`let raw = MovieWatchStatus.watched.rawValue`).

### İstatistikler

`StatisticsViewModel`, izlenmiş `WatchlistMovie` kayıtlarını ve tüm `PersonalMovieRating` kayıtlarını okuyarak toplamları, izleme süresini, ortalama puanı ve puan/tür/yönetmen dağılımlarını hesaplar (en çok izlenen `topDirectorLimit` = 5 yönetmen). `Statistics/Views/Components` içindeki grafikler Swift Charts kullanır.

## Testler

`CineTrackTests/` klasöründe `HomeViewModel`, `SearchViewModel`, `MovieDetailViewModel`, `StatisticsViewModel`, `WatchlistRepository`, `ImageCache`, `TonightViewModel` ve `DiscoverFilters` testleri bulunur. Elle yazılmış mock'lar `CineTrackTests/Mocks/` içindedir (`MockMovieService`, `MockMovieDetailService`, `MockWatchlistRepository`, `MockTonightService`, `MockTonightFilterStore`, …). Bir servis veya repository protokolü değiştiğinde ilgili mock'u da güncelleyin.

## Kurallar

- Arayüz metinleri İngilizcedir. Bazı kod yorumları Türkçedir.
- Her dosyada bir tip bulunur ve standart Xcode başlık yorumu kullanılır.
- View alt bileşenleri ait oldukları özelliğin `Views/Components/` klasöründe durur. Yeniden kullanılabilir gösterim mantığı `Core/Extensions` altında `+Display` extension'ları olarak yazılır.
