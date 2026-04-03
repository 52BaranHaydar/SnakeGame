//
//  GameModels.swift
//  SnakeGame
//
//  Created by Baran on 3.04.2026.
//

// Oyunun temel veri modelleri
// Yeni Konular
// - enum Direction: yön kontrolu
// - struct Position: grid koordinatı
// - enum GameState: oyun durumu

import Foundation

// Yön (Direction)
// enum: sabit değerler kümesi
// Yılanın gidebileceği 4 yön
// CaseIterable: tüm case'leri liste olarak alabilmek için

enum Direction: CaseIterable{
    case up // Yukarı
    case down // Aşağı
    case left // Sol
    case right // Sağ (başlangıç yönü)
    
    // Zıt yön - yılan geriye gidemez!
    // Sağa giderken dola dönemezsin
    var opposite: Direction {
        switch self{
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        }
    }
}

// Positon (Position)
// Oyun tahtasındaki bir karenin koordinatı
// Equatable: == ile karşılaştırabilmek için
// Hashable: WSet içinde kullanabilmek için

struct Position: Equatable, Hashable{
    var x: Int // Yatay Konum (sütun)
    var y: Int // Dikey konum (satır)
    
    // Bir yöne hareket er - yeni pozisyon döner
    // func içinde hesaplama yapıp yeni değer döndürme
    func moved(in direction: Direction) -> Position {
        switch direction{
        case .up: return Position(x: x, y: y - 1)
        case .down: return Position(x: x, y: y + 1)
        case .left:return Position(x: x - 1, y: y)
        case .right: return Position(x: x + 1, y: y)
        }
    }
}


// Oyun Durumu (GameState)
// Oyunun hangi aşamada olduğunu tutar
// HabitTracker'daki DiagnosisState gibi!

enum GameState{
    case waiting // Başlangıç - oyun başlamadı
    case playing // Oyun devam ediyor
    case paused // Duraklat
    case gameOver // Oyun bitti
}

// Oyun Sabitleri
// Değişmeyecek değerleri burada tanımlıyoruz
// enum kullanıyoruz - örneklenmemeli
enum GameConstants {
    // Oyun tahtası boyutu: 20x20 kare
    static let gridSize = 20
    
    // Her karenin piksel boyutu
    static let cellSize: CGFloat = 16
    
    // Oyun hızı: her 0.2 saniyede bir hareket
    // Düşürünce oyun hızlanır!
    static let gameSpeed: TimeInterval = 0.2
    
    // Hızlanma katsayısı: her 5 elmada bir hızlanır
    static let speedIncrement: TimeInterval = 0.01
    static let scorePerFood = 5
    static let foodsPerSpeedup = 5
    
}



