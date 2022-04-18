//
//  ViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 15/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var registerIcon: UIButton!
    @IBOutlet weak var signInIcon: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        //subViews()
        cornerRadius()
    }
    
    func loadImage() {
        let packageGif = UIImage.gifImageWithName("MessengerTRANS")
        gifImage.image = packageGif
    }
    
    func cornerRadius() {
        registerButton.roundedButton()
        signInButton.roundedButton()
        navigationView.layer.cornerRadius = 40
        navigationView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func subViews() {
        backgroundImage.addSubview(registerButton)
        backgroundImage.addSubview(signInButton)
        registerButton.addSubview(registerIcon)
        signInButton.addSubview(signInIcon)
    }
    
    func navigateToSignIn() {
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    func navigateToRegister() {
        let register = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
       navigateToSignIn()
    }

    
    @IBAction func registerButton(_ sender: UIButton) {
        navigateToRegister()
    }
}

extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}





