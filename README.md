# 🎮 SnakeGame

> SwiftUI ile sıfırdan yazılmış klasik Snake oyunu
>
> ![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
> ![iOS](https://img.shields.io/badge/iOS-16%2B-blue?logo=apple)
> ![SwiftUI](https://img.shields.io/badge/SwiftUI-pure-green)
> ![GameLoop](https://img.shields.io/badge/Timer-GameLoop-purple)
>
> ---
>
> ## 📱 Uygulama Hakkında
>
> **SnakeGame**, SpriteKit kullanmadan tamamen SwiftUI ile yazılmış klasik yılan oyunudur. Timer ile oyun döngüsü, Canvas ile yüksek performanslı çizim ve MVVM mimarisi kullanılarak geliştirilmiştir.
>
> ---
>
> ## 🎯 Oyun Kuralları
>
> - Yılanı yönlendir ve elmaları ye
> - - Her elmada yılan uzar ve skor artar
>   - - Duvara veya kendi gövdene çarparsan oyun biter
>     - - Her 5 elmada bir yılan hızlanır
>      
>       - ---
>
> ## ✨ Özellikler
>
> | Özellik | Açıklama |
> |---|---|
> | 🐍 Klasik Snake | Orijinal oyun mekaniği |
> | ⏱ Timer GameLoop | Her 0.2 sn'de oyun güncellenir |
> | 🎨 Canvas Çizim | Yüksek performanslı grid |
> | ⚡ Hızlanma | Her 5 elmada hız artar |
> | ⏸ Duraklat | Oyunu istediğinde durdur |
> | 🏆 En Yüksek Skor | Session boyunca saklanır |
>
> ---
>
> ## 🏗 Mimari — MVVM
>
> ```
> SnakeGame/
> ├── Models/
> │   └── GameModels.swift      # Direction, Position, GameState
> ├── ViewModels/
> │   └── GameViewModel.swift   # Timer, GameLoop, çarpışma kontrolü
> └── Views/
>     ├── ContentView.swift     # Ana ekran, D-Pad kontrol
>     ├── GameBoardView.swift   # Canvas grid, yılan, yemek
>     └── GameOverView.swift    # Skor ekranı
> ```
>
> ---
>
> ## 🆕 Bu Projede Öğrendiklerimiz
>
> | Konu | Açıklama |
> |---|---|
> | `Timer` | Belirli aralıklarla kod çalıştırma |
> | `Canvas` | Yüksek performanslı custom çizim |
> | `GeometryReader` | Dinamik boyut hesaplama |
> | `enum Direction` | Yön kontrolü + .opposite mantığı |
> | `[weak self]` | Retain cycle önleme |
> | `repeat-while` | En az bir kez çalışan döngü |
> | `insert(at: 0)` | Dizinin başına eleman ekleme |
> | `GameState enum` | waiting/playing/paused/gameOver |
>
> ---
>
> ## 🚀 Kurulum
>
> ```bash
> git clone https://github.com/52BaranHaydar/SnakeGame.git
> cd SnakeGame
> open SnakeGame/SnakeGame.xcodeproj
> ```
>
> Xcode açılınca **Cmd + R** ile çalıştır.
>
> ### Gereksinimler
>
> - Xcode 15+
> - - iOS 16+
>   - - Swift 5.9+
>    
>     - ---
>
> ## 🕹 Kontroller
>
> ```
>         ▲
>         ↑
>    ◄ ←   → ►
>         ↓
>         ▼
> ```
>
> Ekrandaki D-Pad butonlarıyla yılanı yönlendir. Duraklat butonu ile oyunu beklet.
>
> ---
>
> ## 🔀 Git Branch Stratejisi
>
> ```
> main              kararlı dal
> └── feature/xyz   her özellik ayrı branch
>     PR → review → merge
> ```
>
> ---
>
> ## 👨‍💻 Geliştirici
>
> **Baran Haydar** — [@52BaranHaydar](https://github.com/52BaranHaydar)
>
> ---
>
> *🎮 Klasik oyunlar, modern Swift ile yeniden doğar.*
