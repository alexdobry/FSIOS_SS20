//
//  CustomView.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 23.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        let t = type(of: self)
        let b = Bundle(for: t)
        let nib = UINib(nibName: String(describing: t), bundle: b)
        
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            contentView = view
            contentView.frame = bounds
            //contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(contentView)
        } else {
            fatalError("cant instantiate custom view form nib")
        }
    }
}
