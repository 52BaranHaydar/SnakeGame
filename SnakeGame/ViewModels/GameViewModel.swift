//
//  GameViewModel.swift
//  SnakeGame
//
//  Created by Baran on 3.04.2026.
//
    
// GameViewModel.swift
// SnakeGame
//
// Oyunun tüm mantığı burada!
// 🆕 YENİ KONULAR:
// - Timer: belirli aralıklarla kod çalıştırma
// - 2D Array: oyun tahtası
// - GameLoop: oyun döngüsü

import SwiftUI
import Combine

// MARK: - GameViewModel
@MainActor
final class GameViewModel: ObservableObject {

    // MARK: - @Published Değişkenler

    // Yılanın gövdesi — Position dizisi
    // İlk eleman = baş, son eleman = kuyruk
    @Published var snake: [Position] = []

    // Yemeğin konumu
    @Published var food: Position = Position(x: 10, y: 10)

    // Mevcut yön
    @Published var direction: Direction = .right

    // Oyun durumu
    @Published var gameState: GameState = .waiting

    // Skor
    @Published var score: Int = 0

    // En yüksek skor
    @Published var highScore: Int = 0

    // MARK: - Private
    // 🆕 Timer: belirli aralıklarla gameLoop fonksiyonunu çağırır
    private var gameTimer: Timer?

    // Sonraki yön — kullanıcı butona basınca güncellenir
    // Aynı frame içinde iki kez yön değişimini önler
    private var nextDirection: Direction = .right

    // Kaç yemek yendi — hızlanma için
    private var foodEaten: Int = 0

    // Mevcut oyun hızı
    private var currentSpeed: TimeInterval = GameConstants.gameSpeed

    // MARK: - Oyun Başlat
    func startGame() {
        // Yılanı ortaya yerleştir — 3 parçalı başlangıç
        let center = GameConstants.gridSize / 2
        snake = [
            Position(x: center, y: center),       // Baş
            Position(x: center - 1, y: center),   // Orta
            Position(x: center - 2, y: center)    // Kuyruk
        ]

        // Başlangıç ayarları
        direction = .right
        nextDirection = .right
        score = 0
        foodEaten = 0
        currentSpeed = GameConstants.gameSpeed
        gameState = .playing

        // Yemeği rastgele yerleştir
        spawnFood()

        // Timer'ı başlat
        startTimer()
    }

    // MARK: - Oyunu Duraklat / Devam Et
    func togglePause() {
        if gameState == .playing {
            gameState = .paused
            stopTimer()
        } else if gameState == .paused {
            gameState = .playing
            startTimer()
        }
    }

    // MARK: - Yön Değiştir
    // Kullanıcı butona basınca çağrılır
    func changeDirection(_ newDirection: Direction) {
        // Zıt yöne gidemez! Sağa giderken sola dönemez
        guard newDirection != direction.opposite else { return }
        nextDirection = newDirection
    }

    // MARK: - Oyun Döngüsü (Game Loop)
    // 🆕 Timer her currentSpeed saniyede bir bunu çağırır
    private func gameLoop() {
        guard gameState == .playing else { return }

        // Yönü güncelle
        direction = nextDirection

        // Yeni baş pozisyonu hesapla
        guard let head = snake.first else { return }
        let newHead = head.moved(in: direction)

        // Duvara çarptı mı?
        if isOutOfBounds(newHead) {
            endGame()
            return
        }

        // Kendine çarptı mı?
        // contains: dizi içinde var mı?
        if snake.contains(newHead) {
            endGame()
            return
        }

        // Yılanı hareket ettir
        // insert: dizinin başına ekle (yeni baş)
        snake.insert(newHead, at: 0)

        // Yemek yedi mi?
        if newHead == food {
            // Yemek yendi — kuyruk uzar (son eleman silinmez)
            score += GameConstants.scorePerFood
            foodEaten += 1

            // En yüksek skoru güncelle
            if score > highScore {
                highScore = score
            }

            // Yeni yemek yerleştir
            spawnFood()

            // Her 5 yemekte hızlan
            if foodEaten % GameConstants.foodsPerSpeedup == 0 {
                speedUp()
            }
        } else {
            // Yemek yenmedi — kuyruk kısalır
            // removeLast: son elemanı sil
            snake.removeLast()
        }
    }

    // MARK: - Yemek Yerleştir
    private func spawnFood() {
        // Yılanın olmadığı rastgele bir konum bul
        var newFood: Position
        repeat {
            // Int.random: rastgele sayı üretir
            newFood = Position(
                x: Int.random(in: 0..<GameConstants.gridSize),
                y: Int.random(in: 0..<GameConstants.gridSize)
            )
            // Yılanın üstüne denk gelirse tekrar dene
        } while snake.contains(newFood)

        food = newFood
    }

    // MARK: - Sınır Kontrolü
    private func isOutOfBounds(_ position: Position) -> Bool {
        position.x < 0 ||
        position.x >= GameConstants.gridSize ||
        position.y < 0 ||
        position.y >= GameConstants.gridSize
    }

    // MARK: - Hızlan
    private func speedUp() {
        currentSpeed = max(
            0.05, // Minimum hız — daha hızlı olmasın
            currentSpeed - GameConstants.speedIncrement
        )
        // Timer'ı yeni hızla yeniden başlat
        stopTimer()
        startTimer()
    }

    // MARK: - Oyun Bitti
    private func endGame() {
        gameState = .gameOver
        stopTimer()
    }

    // MARK: - Timer Yönetimi
    // 🆕 Timer.scheduledTimer: belirli aralıklarla kod çalıştır
    private func startTimer() {
        stopTimer() // Önceki timer varsa durdur
        gameTimer = Timer.scheduledTimer(
            withTimeInterval: currentSpeed,
            repeats: true  // Tekrar tekrar çalış
        ) { [weak self] _ in
            // [weak self]: retain cycle önler
            Task { @MainActor in
                self?.gameLoop()
            }
        }
    }

    private func stopTimer() {
        gameTimer?.invalidate() // Timer'ı durdur
        gameTimer = nil          // Belleği temizle
    }
}
