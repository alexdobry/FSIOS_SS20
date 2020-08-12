//
//  SettingsViewController.swift
//  MatchingCardGame
//
//  Created by Alexander Dobrynin on 30.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: 1. Preparation - Public API
    var increaseValue = 0
    var decreaseValue = 0
    
    // MARK: 2. Outlets
    @IBOutlet weak private var increaseLabel: UILabel!
    @IBOutlet weak private var decreaseLabel: UILabel!
    @IBOutlet weak private var increaseStepper: UIStepper!
    @IBOutlet weak private var decreaseStepper: UIStepper!
    
    private var embededViewController: MatchingCardViewController?
    
    // MARK: 3. viewDidLoad - free to use outlets
    override func viewDidLoad() {
        super.viewDidLoad()

        increaseStepper.value = Double(increaseValue)
        decreaseStepper.value = Double(decreaseValue)
        
        stepperDidChange(increaseStepper)
        stepperDidChange(decreaseStepper)
    }

    @IBAction func stepperDidChange(_ sender: UIStepper) {
        switch sender {
        case increaseStepper:
            let value = Int(increaseStepper.value)
            increaseValue = value
            increaseLabel.text = "Increase Score by \(value)"
        case decreaseStepper:
            let value = Int(decreaseStepper.value)
            decreaseValue = value
            decreaseLabel.text = "Decrease Score by \(value)"
        case _:
            break
        }
    }
    
    @IBAction func lineWidthDidChange(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty, let float = Float(text) {
            print(float)
            embededViewController?.cardViews.forEach { card in
                card.lineWidth = CGFloat(float)
                card.setNeedsDisplay()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed" {
            embededViewController = segue.destination as? MatchingCardViewController
        }
    }
}
