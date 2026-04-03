//
//  GameOverView.swift
//  SnakeGame
//
//  Created by Baran on 3.04.2026.
//

// Oyun bitti ekranı - skor gösterimi ve yeniden başlatma

import SwiftUI

// Oyun Bitti Ekranı
struct GameOverView: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    // Animasyon için state
    @State private var isAnimating: Bool = false
    
    
    var body: some View {
        ZStack{
            // Yarı saydam siyah arka plan
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // Oyun bitti yazısı
                Text("💀")
                    .font(.system(size: 80))
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating
                    )
                
                Text("Oyun Bitti")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                // Skor Kartı
                VStack(spacing: 12) {
                    ScoreRow(
                        label: "Skor",
                        value: "\(viewModel.score)",
                        color: .yellow
                    )
                    
                    ScoreRow(
                        label: "En Yüksek",
                        value: "\(viewModel.highScore)",
                        color: .orange
                    )
                }
                .padding(20)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
                
                // Butonlar
                VStack(spacing: 12) {
                    
                    // Tekrar oyna
                    Button{
                        withAnimation(.spring(duration: 0.4)){
                            viewModel.startGame()
                        }
                    } label: {
                        Label("Tekrar Oyna", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.green)
                            .cornerRadius(14)
                    }
                    
                    // Ana Menü
                    Button{
                        withAnimation(.easeInOut) {
                            viewModel.gameState = .waiting
                        }
                    } label: {
                        Text("Ana Menü")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal,32)
            }
            .padding(32)
        }
        .onAppear { isAnimating = true }
    }
}

struct ScoreRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack{
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(color)
        }
    }
}


#Preview {
    GameOverView(viewModel: {
        let vm = GameViewModel()
        vm.score = 25
        vm.highScore = 50
        vm.gameState = .gameOver
        return vm
    }())
}
