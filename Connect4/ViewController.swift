//
//  ViewController.swift
//  Connect4
//
//  Created by COMP47390 on 20/01/2022.
//  Copyright © 2020 COMP47390. All rights reserved.
//

import UIKit
import Alpha0Connect4

class ViewController: UIViewController {
    // MARK : - UI Outlets
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var dropDiscButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // Set random bot parameters
    private var botColor: GameSession.DiscColor = Bool.random() ? .red : .yellow
    private var isBotFirst = Bool.random()
    // Game session
    private var gameSession = GameSession()

    // MARK - VC lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start new game session
        newGameSession()
    }

    
    // Start game session with random bot parameter
    private func newGameSession() {
        // Random bot parameters
        botColor = Bool.random() ? .red : .yellow
        isBotFirst = Bool.random()
        
        // Print game layout
        print("CONNECT4 \(gameSession.boardLayout.rows) rows by \(gameSession.boardLayout.columns) columns")
        
        // Start game, resuming with some discs
        // set initialMoves to [(Int, Int)]() to start with clear board
        let initialMoves = [(row: 1, column: 4), (row: 2, column: 4)]
        self.gameSession.startGame(delegate: self, botPlays: self.botColor, first: self.isBotFirst, initialPositions: initialMoves)
    }

    
    // MARK - UI Action
    @IBAction func userAction(_ sender: UIButton) {
        // Drop disc in random column
        var column: Int
        repeat { column = Int.random(in: 1...gameSession.boardLayout.columns) }
        while !gameSession.isValidMove(column)

        // Drop disc
        gameSession.dropDiscAt(column)
    }

}


// MARK: - GameSessionProtocol

extension ViewController: GameSessionProtocol
{
    // GameSessionProtocol update for game state changes
    func stateChanged(_ gameSession: GameSession, state: SessionState, for playerTurn: DiscColor, textLog: String) {
        // Handle state transition
        print(state)
        switch state
        {
        // Inital state
        case .cleared:
            gameLabel.text = textLog
            dropDiscButton.titleLabel?.text = "Drop Disc Randomly"
            // Enable button if player turn is user
            let isUserTurn = (playerTurn != botColor)
            dropDiscButton.isEnabled = isUserTurn
            
        // Player evaluating position to play
        case .thinking(_):
            // Disable button while thinking
            dropDiscButton.isEnabled = false
            
        // Waiting for player to play
        case .idle(let color):
            // If player is bot, drop piece automatically
            // otherwise enable drop disc button
            if color == botColor {
                dropDiscButton.isEnabled = false
                gameSession.dropDisc()
            } else {
                dropDiscButton.isEnabled = true
                print("waiting for \(color)")
            }
            
        // End of game, update UI with game result, start new game
        case .ended(let outcome):
            // Disable button
            dropDiscButton.isEnabled = false
            
            // Display game result
            var gameResult: String
            switch outcome {
            case botColor:
                gameResult = "Bot (\(botColor)) wins!"
            case !botColor:
                gameResult = "User (\(!botColor)) wins!"
            default:
                gameResult = "Draw!"
            }
            gameLabel.text! = textLog + "\n" + gameResult
            
            // Wait a while and start a new session automatically
            indicatorView.startAnimating()
            Task {
                try await Task.sleep(nanoseconds: 5_000_000_000)
                await MainActor.run {
                    indicatorView.stopAnimating()
                    newGameSession()
                }
            }
            
        @unknown default:
            break
        }
    }
    
    
    // GameSessionProtocol notifying of the result of a player action
    // textLog provides some string visualization of the game board for debug purposes
    func didDropDisc(_ gameSession: GameSession, color: DiscColor, at location: (row: Int, column: Int), index: Int, textLog: String) {
        print("\(color) drops at \(location)")
        self.gameLabel.text = textLog
    }

    
    // GameSessionProtocol notification of next player to play
    func turnToPlay(_ gameSession: GameSession, color: DiscColor) {
        print("\(color) turn")
    }

    
    // GameSessionProtocol notification of end of game
    func didEnd(_ gameSession: GameSession, color: DiscColor?, winningActions: [(row: Int, column: Int)]) {
        // Display winning disc positions
        print(winningActions.map({"\($0)"}).joined(separator: " "))
    }

}



