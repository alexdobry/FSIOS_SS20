//
//  Card+Image.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 30.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import UIKit

extension Card {
    
    var image: UIImage {
        let rank: String
        let suit: String
        
        switch self.rank {
        case .J:
            rank = "jack"
        case .Q:
            rank = "queen"
        case .K:
            rank = "king"
        case .A:
            rank = "ace"
        default:
            rank = self.rank.rawValue
        }
        
        switch self.suit {
        case .spade:
            suit = "spades"
        case .club:
            suit = "clubs"
        case .heart:
            suit = "hearts"
        case .diamond:
            suit = "diamonds"
        }
        
        return UIImage(named: "\(rank)_of_\(suit)")!
    }
}
