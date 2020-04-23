//
//  MatchingCardGame.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 16.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import Foundation

protocol MatchingCardGameDelegate {
    func matchingCardGame(_ game: MatchingCardGame, scoreDidChangeTo value: Int)
}

final class MatchingCardGame {
    enum State {
        case nowPending(Card)
        case match(pending: Card, newCard: Card)
        case noMatch(pending: Card, newCard: Card)
        case alreadySelected(Card)
    }
    
    private var cards: [Card] = []
    private var pendingCard: Card?
    
    var delegate: MatchingCardGameDelegate?
    
    private var score: Int = 0 {
        didSet {
            delegate?.matchingCardGame(self, scoreDidChangeTo: score)
        }
    }
    
    init(numberOfCards: Int) {
        var deck = Deck()
        
        guard deck.cards.count >= numberOfCards else {
            fatalError("not enough cards in deck")
        }
        
        for _ in (0..<numberOfCards) {
            cards.append(deck.drawRandomCard()!)
        }
        
        score = 0
    }
    
    func flipCard(at index: Int) -> State {
        let card = cards[index]
        
        if card == pendingCard {
            return .alreadySelected(card)
        }
        
        if let pending = pendingCard {
            pendingCard = nil
            
            if pendingCard(pending, isMatchingWith: card) {
                score += 3
                return .match(pending: pending, newCard: card)
            } else {
                score -= 3
                return .noMatch(pending: pending, newCard: card)
            }
        } else {
            pendingCard = card
            return .nowPending(card)
        }
    }
    
    func pendingCard(_ pending: Card, isMatchingWith other: Card) -> Bool {
        return pending.suit == other.suit ||
            pending.rank == other.rank
    }
}
