//
//  CardView.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 23.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import UIKit

class CardView: CustomView {
    
    var cardViewFlippedCard: (CardView) -> Void = { _ in }
    
    @IBOutlet weak private var cardImageView: UIImageView!
    
    var card: Card? {
        didSet {
            UIView.transition(
                with: self,
                duration: 0.3,
                options: card != nil ? .transitionFlipFromLeft : .transitionFlipFromRight,
                animations: {
                    if let card = self.card {
                        self.cardImageView.image = card.image
                    } else {
                        self.cardImageView.image = #imageLiteral(resourceName: "card_back")
                    }
                },
                completion: nil
            )
        }
    }
    
    var matched: Bool = false {
        didSet {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: [],
                animations: {
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.5,
                        animations: {
                            self.transform = CGAffineTransform.identity
                            self.alpha = self.matched ? 0.5 : 1.0
                            self.isUserInteractionEnabled = !self.matched
                        },
                        completion: nil
                    )
                }
            )
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        cardViewFlippedCard(self)
    }
}
