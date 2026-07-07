![Swift](https://img.shields.io/badge/Swift-6-orange)
![Platform](https://img.shields.io/badge/iOS-18+-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-green)
![Architecture](https://img.shields.io/badge/MVVM-Repository-red)

# 🎬 CineTrack

A modern movie discovery app built with **SwiftUI** using **MVVM**, **Repository Pattern**, **Dependency Injection**, and **SwiftData**.

Browse trending, popular, and top-rated movies, search instantly with debounce, watch trailers, explore cast information, and build your personal watchlist.

---

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/17e2d2c9-b4c1-4056-bfe4-bf80a4169531" width="24%" />
  <img src="https://github.com/user-attachments/assets/d350a481-b41c-4228-b94c-b92ff266d6d4" width="24%" />
  <img src="https://github.com/user-attachments/assets/f934b852-4b25-4c50-b4ba-03d9836e34de" width="24%" />
  <img src="https://github.com/user-attachments/assets/771fa027-5da7-4f9c-9bc8-f4ce8c4c4f6d" width="24%" />
</p>


---

## ✨ Features

- 🎬 Trending, Popular and Top Rated movies
- 🔍 Real-time movie search with debounce
- 📄 Detailed movie information
- ▶️ Watch official trailers
- ⭐ Add and remove movies from your Watchlist
- 👥 Cast information
- 🎞 Similar movie recommendations
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
Repository
    │
    ▼
Service
    │
    ▼
Network Layer
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

- Swift 6
- SwiftUI
- Swift Concurrency
- URLSession
- SwiftData
- TMDB API
- XCTest & Swift Testing
- MVVM
- Repository Pattern
- Dependency Injection

---

## 📂 Project Structure

```
App
Core
Features
Models
Resources
Tests
```

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/JiyanAtalay/CineTrack.git
```

Create a `Config.plist` inside the **Resources** folder and add your TMDB API key:

```
TMDB_API_KEY = YOUR_API_KEY
```

You can get a free API key from https://www.themoviedb.org/settings/api

Run the project using **Xcode 16+**.

---

## 🧪 Testing

The project includes Unit Tests and UI Tests.

Covered components include:

- HomeViewModel
- SearchViewModel
- MovieDetailViewModel
- WatchlistRepository
- ImageCache

---

## 📚 What I Learned

- Building scalable SwiftUI applications
- Repository Pattern
- Dependency Injection
- SwiftData
- Generic networking
- Image caching
- Async/Await
- Debounced search
- Pagination
- Unit Testing
- UI Testing
- Clean Architecture

---

## 👨‍💻 Author
**Mehmet Jiyan Atalay** * LinkedIn: [Mehmet Jiyan Atalay](https://www.linkedin.com/in/jiyan-atalay-407360279/)
* GitHub: [@JiyanAtalay](https://github.com/JiyanAtalay)
