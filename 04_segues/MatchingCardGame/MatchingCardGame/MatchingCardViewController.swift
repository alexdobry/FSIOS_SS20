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
    @IBOutlet var cardViews: [DrawingCardView]!
    
    lazy var game = MatchingCardGame(numberOfCards: cardViews.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        
        cardViews.forEach { cardView in
            cardView.cardViewFlippedCard = flipCard
        }
        
        dealCards()
    }
    
    
    // MARK: Model <-> View
    
    func flipCard(cardView: DrawingCardView) {
        let index = cardViews.firstIndex(of: cardView)!
        let res = game.flipCard(at: index)

        switch res {
        case .nowPending(let card):
            cardView.card = card
        case .match(let pending, let newCard):
            cardView.card = newCard
            cardView.matched = true
            
            for cardView in cardViews {
                if cardView.card == pending {
                    cardView.matched = true
                }
            }
            
        case .noMatch(let pending, let newCard):
            cardView.card = newCard

            memorize(newCard, pending: pending)
        case .alreadySelected(_):
            UIView.animate(
                withDuration: 0.07,
                delay: 0.0,
                options: [.repeat],
                animations: {
                    UIView.setAnimationRepeatCount(2)
                    cardView.frame.origin.x -= 5
                    cardView.frame.origin.x += 5
            },
                completion: nil
            )
        }
    }

    func memorize(_ card: Card, pending: Card) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.cardViews
                .filter { $0.card == card || $0.card == pending }
                .forEach { $0.card = nil }
        }
    }
    
    private func dealCards() {
        func moveToBottomEdge() {
            let bottomEdge = CGPoint(x: view.frame.width / 2, y: view.frame.height)
            
            cardViews.forEach { cardView in
                let dx = bottomEdge.x - cardView.center.x
                let dy = bottomEdge.y - cardView.center.y - cardView.bounds.height / 2
                
                cardView.transform = CGAffineTransform(translationX: dx, y: dy)
            }
        }

        func deal() {
            let totalDuration = Double(1)
            let singleDuration = 1 / Double(cardViews.count)
            
            cardViews.shuffled().enumerated().forEach { (i, cardView) in
                let delay = singleDuration * Double(i)
                
                UIView.animate(
                    withDuration: totalDuration,
                    delay: delay,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0.2,
                    animations: {
                        cardView.transform = CGAffineTransform.identity
                    }
                )
            }
        }
        
        moveToBottomEdge()
        deal()
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            let nav = segue.destination as! UINavigationController
            let dvc = nav.topViewController as! SettingsViewController
            
            dvc.increaseValue = game.scoreIncrease
            dvc.decreaseValue = game.scoreDecrease
        }
    }
    
    @IBAction func unwindToMatchingCardViewController(_ unwindSegue: UIStoryboardSegue) {
        let svc = unwindSegue.source as! SettingsViewController
        game.scoreIncrease = svc.increaseValue
        game.scoreDecrease = svc.decreaseValue
    }
}

extension Card: Equatable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank &&
            lhs.suit == rhs.suit
    }
}

extension MatchingCardViewController: MatchingCardGameDelegate {
    func matchingCardGame(_ game: MatchingCardGame, scoreDidChangeTo value: Int) {
        scoreLabel.text = "Score: \(value)"
    }
}
