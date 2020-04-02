//
//  ViewController.swift
//  Test
//
//  Created by Alexander Dobrynin on 02.04.20.
//  Copyright © 2020 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    
    var counter: Int = 0 {
        didSet {
            counterLabel.text = "Mein Counter ist \(counter)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UITapGestureRecognizer
        
        counter = 0
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        counter += 1
    }
    
}

