//
//  ContentView.swift
//  SnakeGame
//
//  Created by Baran on 3.04.2026.
//
 
// Ana ekran - oyun durumuna göre doğru View'ı gösterir
// Yeni : gesture ile kontrol, overlay, ZStack mantığı

// ContentView.swift
// SnakeGame
//
// Ana ekran — düzeltilmiş versiyon
// Tahta tam ekran, kontroller altta sabit

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {

                    // --- Üst bilgi şeridi ---
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SKOR")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.gray)
                            Text("\(viewModel.score)")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.white)
                                .monospacedDigit()
                        }

                        Spacer()

                        if viewModel.gameState == .playing ||
                           viewModel.gameState == .paused {
                            Button {
                                viewModel.togglePause()
                            } label: {
                                Image(systemName: viewModel.gameState == .paused
                                      ? "play.fill" : "pause.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                            }
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("EN YÜKSEK")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.gray)
                            Text("\(viewModel.highScore)")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.yellow)
                                .monospacedDigit()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)

                    // --- Oyun Tahtası ---
                    // Kare alan hesapla — kontrol için yer bırak
                    let controlHeight: CGFloat = viewModel.gameState == .playing ? 200 : 0
                    let topBarHeight: CGFloat = 60
                    let availableHeight = geometry.size.height
                        - controlHeight
                        - topBarHeight
                        - geometry.safeAreaInsets.top
                        - geometry.safeAreaInsets.bottom
                    let boardSize = min(geometry.size.width - 16, availableHeight - 16)

                    ZStack {
                        GameBoardView(viewModel: viewModel)
                            .frame(width: boardSize, height: boardSize)

                        // Overlay'ler tahtanın üstüne
                        switch viewModel.gameState {
                        case .waiting:
                            WelcomeOverlay(viewModel: viewModel)
                                .frame(width: boardSize, height: boardSize)
                        case .paused:
                            PausedOverlay(viewModel: viewModel)
                                .frame(width: boardSize, height: boardSize)
                        case .gameOver:
                            GameOverView(viewModel: viewModel)
                                .frame(width: boardSize, height: boardSize)
                        case .playing:
                            EmptyView()
                        }
                    }
                    .frame(width: boardSize, height: boardSize)

                    // --- Kontrol Tuş Takımı ---
                    if viewModel.gameState == .playing {
                        Spacer()
                        ControlPad(viewModel: viewModel)
                            .frame(height: 180)
                        Spacer()
                    } else {
                        Spacer()
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Hoşgeldin Ekranı
struct WelcomeOverlay: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .cornerRadius(12)

            VStack(spacing: 16) {
                Text("🐍")
                    .font(.system(size: 72))
                    .scaleEffect(isAnimating ? 1.15 : 0.85)
                    .animation(
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                Text("Snake")
                    .font(.system(size: 44, weight: .black))
                    .foregroundColor(.green)

                Text("Elmayı ye, büyü!\nDuvara veya kendine çarpma!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)

                Button {
                    withAnimation { viewModel.startGame() }
                } label: {
                    Text("OYNA")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.black)
                        .frame(width: 160, height: 52)
                        .background(Color.green)
                        .cornerRadius(14)
                }
            }
            .padding(24)
        }
        .onAppear { isAnimating = true }
    }
}

// MARK: - Duraklatıldı Ekranı
struct PausedOverlay: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .cornerRadius(12)

            VStack(spacing: 20) {
                Text("⏸")
                    .font(.system(size: 56))

                Text("Duraklatıldı")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)

                Button {
                    viewModel.togglePause()
                } label: {
                    Label("Devam Et", systemImage: "play.fill")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 180, height: 50)
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
        }
    }
}

// MARK: - Kontrol Tuş Takımı
struct ControlPad: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 8) {
            DirectionButton(icon: "chevron.up") {
                viewModel.changeDirection(.up)
            }
            HStack(spacing: 48) {
                DirectionButton(icon: "chevron.left") {
                    viewModel.changeDirection(.left)
                }
                DirectionButton(icon: "chevron.right") {
                    viewModel.changeDirection(.right)
                }
            }
            DirectionButton(icon: "chevron.down") {
                viewModel.changeDirection(.down)
            }
        }
    }
}

// MARK: - Yön Butonu
struct DirectionButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(
                    Circle()
                        .fill(Color.white.opacity(isPressed ? 0.35 : 0.15))
                )
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
