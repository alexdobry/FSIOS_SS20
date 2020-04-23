//
//  Deck.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 16.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Suit: String, CaseIterable {
    case spade = "♠️"
    case club = "♣️"
    case heart = "❤️"
    case diamond = "♦️"
}

enum Rank: String, CaseIterable {
    case two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", ten = "10"
    case J, Q, K, A
}

struct Card {
    var suit: Suit
    var rank: Rank
}

extension Card: CustomStringConvertible {
    var description: String {
        return "\(suit.rawValue)\(rank.rawValue)"
    }
}

struct Deck {
    var cards: [Card] = []
    
    init() {
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
        
        cards.shuffle()
    }
    
    mutating func drawRandomCard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        
        return cards.removeFirst()
    }
}
