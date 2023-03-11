//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Maximilian Berndt on 2023/03/11.
//

import SwiftUI

enum GameAction: CaseIterable {
    case Rock
    case Paper
    case Scissors
    
    func toImage() -> Image {
        switch self {
        case .Rock: return Image(systemName: "volleyball")
        case .Paper: return Image(systemName: "hand.raised.fingers.spread")
        case .Scissors: return Image(systemName: "scissors")
        }
    }
}

struct GameActionButton: View {
    
    var data: GameAction
    var action: (GameAction) -> ()
    
    var body: some View {
        Button {
            action(data)
        } label: {
            data.toImage()
                .resizable()
                .frame(width: 32, height: 32)
        }.foregroundColor(.black)
    }
}

struct ContentView: View {
    
    @State private var currentAction: GameAction = GameAction.allCases.randomElement()!
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var gamesPlayed = 1
    
    @State private var scoreTitle = ""
    
    @State private var showingScore = false
    @State private var showingNewGame = false
    
    private var correctAnswer: GameAction {
        switch currentAction {
        case .Rock: return shouldWin ? .Paper : .Scissors
        case .Paper: return shouldWin ? .Scissors : .Rock
        case .Scissors: return shouldWin ? .Rock : .Paper
        }
    }
    
    private var winColor = Color(red: 34 / 255, green: 139 / 255, blue: 34 / 255)
    private var loseColor = Color(red: 0.76, green: 0.15, blue: 0.26)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: shouldWin ? winColor : loseColor, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack(spacing: 30) {
                Spacer()
                Text("Rock Paper Scissors")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Current Move")
                            .font(.title.bold())
                        currentAction.toImage()
                            .font(.largeTitle)
                    }
                    Divider()
                    Text("Please \(shouldWin ? "Win" : "Lose")")
                        .font(.largeTitle.bold())
                    HStack(spacing: 50) {
                        ForEach(GameAction.allCases, id: \.self) { action in
                            GameActionButton(data: action) { action in
                                gameActionTapped(action: action)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding()
                Spacer()
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: next)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Final Score", isPresented: $showingNewGame) {
            Button("New Game", action: newGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    private func gameActionTapped(action: GameAction) {
        if action == correctAnswer {
            score += 1
            scoreTitle = "Correct :)"
        } else {
            scoreTitle = "Incorrect :("
        }
        
        if gamesPlayed == 3 {
            showingNewGame = true
        } else {
            showingScore = true
        }
    }
    
    private func next() {
        currentAction = GameAction.allCases.randomElement()!
        shouldWin = Bool.random()
        gamesPlayed += 1
    }
    
    private func newGame() {
        score = 0
        gamesPlayed = 0
        next()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
