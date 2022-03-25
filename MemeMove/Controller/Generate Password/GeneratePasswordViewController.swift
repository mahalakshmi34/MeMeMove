//
//  GeneratePasswordViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit

class GeneratePasswordViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordGenerationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cornerRadius()
    }
    
    func cornerRadius() {
        passwordGenerationView.layer.cornerRadius = 40
        passwordGenerationView.layer.borderWidth = 5
        passwordGenerationView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
    }

   

}
