//
//  DrawingCardView.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 30.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import UIKit

fileprivate extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

@IBDesignable
class DrawingCardView: UIView {
    
    var cardViewFlippedCard: (DrawingCardView) -> Void = { _ in }
    
    var card: Card? {
        didSet {
            UIView.transition(
                with: self,
                duration: 0.3,
                options: card != nil ? .transitionFlipFromLeft : .transitionFlipFromRight,
                animations: {
                    self.setNeedsDisplay()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard)))
    }
    
    @objc func flipCard() {
        cardViewFlippedCard(self)
    }
    
    @IBInspectable
    var lineColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    @IBInspectable
    var cardColor: UIColor = #colorLiteral(red: 0.8412953019, green: 0.2027314007, blue: 0.5099305511, alpha: 1)
    
    @IBInspectable
    var lines: Int = 12
    
    @IBInspectable
    var lineWidth: CGFloat = 5

    override func draw(_ rect: CGRect) {
        if let card = card {
            drawFront(for: card)
        } else {
            drawBack()
        }
    }
    
    private func drawFront(for card: Card) {
        card.image.draw(in: bounds)
    }
    
    private func drawBack() {
        let roundedRect = pathForRoundedRect()
        cardColor.setFill()
        roundedRect.fill()
        
        let linePaths = pathFor(lines: lines)
        lineColor.setStroke()
        linePaths.stroke()
    }
    
    private func pathForRoundedRect() -> UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
    }
    
    private func pathFor(lines: Int) -> UIBezierPath {
        func drawLine(at path: UIBezierPath, with offset: CGFloat) {
            path.move(to: path.currentPoint.offsetBy(dx: 0, dy: offset))
            
            let direction = path.currentPoint.x == bounds.minX ? 1 : -1
            path.addLine(to: path.currentPoint.offsetBy(dx: CGFloat(direction) * bounds.maxX, dy: 0))
        }
        
        func rotate(_ path: UIBezierPath, by angle: CGFloat, offsettedBy offset: CGFloat) {
            path.lineWidth = lineWidth
            path.apply(CGAffineTransform(translationX: -bounds.midX, y: -bounds.midY))
            path.apply(CGAffineTransform(scaleX: 2.0, y: 1))
            path.apply(CGAffineTransform(rotationAngle: angle))
            path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY - ((offset + (lineWidth / 2)) / 2)))
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        
        let offset = bounds.height / CGFloat(lines)
        
        (1...lines).forEach { _ in
            drawLine(at: path, with: offset)
        }
        
        rotate(path, by: -CGFloat.pi / 4, offsettedBy: offset)
        
        return path
    }

}
