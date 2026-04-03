//
//  GameBoardView.swift
//  SnakeGame
//
//  Created by Baran on 3.04.2026.
//

import SwiftUI

struct GameBoardView: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    
    var body: some View {
        // GeometryReader: parent container boyutunu okur
        GeometryReader { geometry in
            let cellSize = min(
                geometry.size.width,
                geometry.size.height
            ) / CGFloat(GameConstants.gridSize)
            
            ZStack{
                // Arka plan girdi
                GridBackground(cellSize: cellSize)
                
                // Yemek
                FoodView(
                    position: viewModel.food,
                    cellSize: cellSize
                )
                
                // Yılan
                ForEach(0..<viewModel.snake.count, id: \.self) { index in
                    SnakeCellView(
                        position: viewModel.snake[index],
                        isHead: index == 0,
                        cellSize: cellSize
                    )
                    
                }
                
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .background(Color.black)
        .cornerRadius(12)
    }
}

// MARK: - Grid Arka Plan
struct GridBackground: View {
    let cellSize: CGFloat

    var body: some View {
        Canvas { context, size in
            let gridSize = GameConstants.gridSize

            for i in 0...gridSize {
                let pos = CGFloat(i) * cellSize

                // Dikey çizgi
                var verticalPath = Path()
                verticalPath.move(to: CGPoint(x: pos, y: 0))
                verticalPath.addLine(to: CGPoint(x: pos, y: size.height))
                context.stroke(
                    verticalPath,
                    with: .color(.white.opacity(0.05)),
                    lineWidth: 0.5
                )

                // Yatay çizgi
                var horizontalPath = Path()
                horizontalPath.move(to: CGPoint(x: 0, y: pos))
                horizontalPath.addLine(to: CGPoint(x: size.width, y: pos))
                context.stroke(
                    horizontalPath,
                    with: .color(.white.opacity(0.05)),
                    lineWidth: 0.5
                )
            }
        }
    }
}

struct SnakeCellView: View {
    
    let position: Position
    let isHead: Bool
    let cellSize: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: isHead ? 4 : 3)
            .fill(isHead ? Color.green : Color.green.opacity(0.7))
            .overlay(
                // Baş için gözler
                Group{
                    if isHead {
                        HStack(spacing: cellSize * 0.2) {
                            Circle()
                                .fill(Color.black)
                                .frame(
                                    width: cellSize * 0.2,
                                    height: cellSize * 0.2
                                )
                            Circle()
                                .fill(Color.black)
                                .frame(
                                    width: cellSize * 0.2,
                                    height: cellSize * 0.2
                                )
                        }
                    }
                }
            )
            .frame(width: cellSize - 1, height: cellSize - 1)
            // Pozisyona göre konumlandır
            .position(
                x: CGFloat(position.x) * cellSize + cellSize / 2,
                y: CGFloat(position.y) * cellSize + cellSize / 2
            )
    }
}

struct FoodView: View {
    
    let position: Position
    let cellSize: CGFloat
    
    // Yemek için titreme animasyonu
    @State private var isAnimating = false
    
    var body: some View {
        Text("🍎")
            .font(.system(size: cellSize * 0.8))
            .frame(width: cellSize, height: cellSize)
            // Hafif büyüyüp küçülme animasyonu
            .scaleEffect(isAnimating ? 1.1 : 0.9)
            .animation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .position(
                x: CGFloat(position.x) * cellSize + cellSize / 2,
                y: CGFloat(position.y) * cellSize + cellSize / 2
            )
            .onAppear{ isAnimating = true}
    }
}


#Preview {
    GameBoardView(viewModel: {
        let vm = GameViewModel()
        vm.startGame()
        return vm
    }())
    .padding()
    .background(Color(.systemBackground))
}
