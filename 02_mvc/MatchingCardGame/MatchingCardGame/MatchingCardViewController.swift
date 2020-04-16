//
//  MatchingCardViewController.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 16.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MatchingCardViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    lazy var game = MatchingCardGame(numberOfCards: cardButtons.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
    }
    
    @IBAction func flipCard(_ sender: UIButton) {
        let index = cardButtons.firstIndex(of: sender)!
        let res = game.flipCard(at: index)
        
        switch res {
        case .nowPending(let card):
            sender.faceUp(with: card)
        case .match(_, let newCard):
            sender.faceUp(with: newCard)
        case .noMatch(let pending, let newCard):
            sender.faceUp(with: newCard)
        
            memorize(newCard, pending: pending)
        }
    }
    
    func memorize(_ card: Card, pending: Card) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.cardButtons
                .filter { $0.currentTitle == card.description ||
                    $0.currentTitle == pending.description }
                .forEach { $0.faceDown() }
        }
    }
}

extension MatchingCardViewController: MatchingCardGameDelegate {
    func matchingCardGame(_ game: MatchingCardGame, scoreDidChangeTo value: Int) {
        scoreLabel.text = "Score: \(value)"
    }
}

fileprivate extension UIButton {
    
    var facedDown: Bool {
        return currentTitle == nil
    }
    
    func faceUp(with card: Card) {
        setBackgroundImage(UIImage(named: "card_front"), for: .normal)
        setTitle(card.description, for: .normal)
    }
    
    func faceDown() {
        setBackgroundImage(UIImage(named: "card_back"), for: .normal)
        setTitle(nil, for: .normal)
    }
}
