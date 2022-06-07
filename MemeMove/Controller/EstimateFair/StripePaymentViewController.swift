//
//  StripePaymentViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 04/06/22.
//

import UIKit
import Stripe
import ProgressHUD
import Alamofire
import SwiftyJSON


class StripePaymentViewController: UIViewController,STPAddCardViewControllerDelegate,STPPaymentCardTextFieldDelegate,UITextFieldDelegate {
   
    @IBOutlet weak var mainView: UIView!
    
    var clientSecretValue = ""
    var transcationStatus = ""
    var transcationID = ""
    var userPay = 0.0
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
    }
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
      }()
    
    lazy var payButton: UIButton = {
       let button = UIButton(type: .custom)
       button.layer.cornerRadius = 5
       button.backgroundColor = .systemBlue
       button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Pay now", for: .normal)
       button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
      }()

    override func viewDidLoad() {
        super.viewDidLoad()

        StripeAPI.defaultPublishableKey = "pk_test_51KkUVZJAvb7prcutR1BIs51QQMPXNY7AIFrcoR12f4Fo5XrhYiJIUJzmjc4yBjuSo7SwjJMMZTY4IwweUlEST8Cs00L4c7pY6Q"
        
        view.addSubview(payButton)
        
        payment()
        
        stripePayment()
    }
    
    
    func  payment() {
     
        StripeAPI.defaultPublishableKey = "pk_test_51KkUVZJAvb7prcutR1BIs51QQMPXNY7AIFrcoR12f4Fo5XrhYiJIUJzmjc4yBjuSo7SwjJMMZTY4IwweUlEST8Cs00L4c7pY6Q"

        view.backgroundColor = .white
            var stackView = UIStackView(arrangedSubviews: [cardTextField])
           stackView.axis = .vertical
           stackView.spacing = 20
           stackView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(stackView)
          NSLayoutConstraint.activate([
              stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
             view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
             stackView.topAnchor.constraint(equalToSystemSpacingBelow: mainView.bottomAnchor, multiplier: 2),
           stackView.heightAnchor.constraint(equalToConstant: 40)
           // checkBox.translatesAutoresizingMaskIntoConstraints = false
          ])
        

        payButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            payButton.topAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1),
            payButton.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: payButton.rightAnchor, multiplier: 2),
           payButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        // startCheckout()
    }
    
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
    }
    
    func stripePayment() {
        
        if UserDefaults.standard.double(forKey: "userPay") != nil {
            userPay = UserDefaults.standard.double(forKey: "userPay")
        }
     
        let url = "https://api.mememove.com:8443/MeMeMove/Order/stripe/pay?amnt=100&currency=usd&method=card"
        
        
        let parameter : Parameters = [
            "amnt" : 100,
            "currency" : "usd",
            "method" : "card"
        ]
        
        let header :HTTPHeaders = ["Content-Type" : "application/json"]
        

        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default,headers: header)
            .responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
            print("isi: \(data)")
            let json = JSON(data)
                print(json)
                
                if let clientSecretData = json["client_secret"].string {
                    print(clientSecretData)
                    clientSecretValue = clientSecretData
                    UserDefaults.standard.set(clientSecretValue, forKey: "clientSecret")
                    clientSecretValue = UserDefaults.standard.string(forKey: "clientSecret")!
                }
            
               
            case .failure(let error):
                print("Request failed with error: \(error)")
                }
            }
    }
    
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
     DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel))
       self.present(alert, animated: true, completion: nil)
      }
    }
    
    @objc
      func pay() {
      
        let cardParameter :STPCardParams = STPCardParams()
        cardParameter.number = cardTextField.cardNumber
        cardParameter.cvc = cardTextField.cvc
        cardParameter.expMonth = UInt(cardTextField.expirationMonth)
        cardParameter.expYear = UInt(cardTextField.expirationYear)
        cardParameter.addressZip = cardTextField.postalCode
      
        if  cardTextField.postalCode!.count > 8 {
            displayAlert(title: "Alert", message: "Invalid postal code")
        }
        else {
            ProgressHUD.show()
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorAnimation = .systemBlue
           // tokenCard()
           // clientSecretCode()
            
            let cardParams = cardTextField.cardParams
            let paymentMethodParams = STPPaymentMethodParams(card: cardParams,billingDetails: nil,metadata: nil)
            
           // var paymentMethodParams : STPPaymentMethodParams?
            
            
            let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecretValue)
            paymentIntentParams.paymentMethodParams = paymentMethodParams
           
            
       //     submitPayment(intent:paymentIntentParams) { status, intent , error in
                        
            let paymentHandler = STPPaymentHandler.shared()
            paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { [self] (status, paymentIntent, error) in
                
                
                var resultString = ""
                           switch (status) {
                           case .failed:
                            resultString = "Payment canceled"
                               self.transcationStatus = "false"
                               self.displayAlert(title: "Payment failed", message: "Failed")
                           // UserDefaults.standard.set(transcationStatus, forKey: "transcationStatus")
                               break
                           case .canceled:
                               resultString = "Payment failed"
                               self.transcationStatus = "false"
                               self.displayAlert(title: "Payment canceled", message: "failed")
//                               transcationStatus = "false"
//                            UserDefaults.standard.set(transcationStatus, forKey: "transcationStatus")
                               break
                           case .succeeded:
                               
                            resultString = "Payment Sucess"
                               self.transcationStatus = "true"
                             
                               UserDefaults.standard.removeObject(forKey: "payAmount")
           
                            let alert = UIAlertController(title: "Payment Sucess", message: "Sucess", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: {_ in
                                ProgressHUD.dismiss()

//                              let homeVC = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//                               self.navigationController?.pushViewController(homeVC, animated: true)
                            }))
                            // updateDeposit(Status : transcationStatus)
                            self.present(alert, animated: true, completion: nil)
                               
                               print(paymentIntent?.status)
                            
                            transcationID = paymentIntent!.stripeId
                            UserDefaults.standard.set(transcationID, forKey: "transcationID")
                               
                            var transcationStatus = paymentIntent?.status
                            UserDefaults.standard.set(transcationStatus, forKey: "transcationStatus")

                            print(paymentIntent?.status)
                            print(paymentIntent?.stripeId)
                               
                           break
                           
                           @unknown default:
                               fatalError()
                               break
                         }
            }
        }
       // var cardSave = cardTextField.text
            
      }
}

extension StripePaymentViewController : STPAuthenticationContext {

func authenticationPresentingViewController() -> UIViewController {
    return self
}

func submitPayment(intent:STPPaymentIntentParams , completion:@escaping (STPPaymentHandlerActionStatus,STPPaymentIntent? , NSError?) -> Void) {
    let paymentHandler = STPPaymentHandler.shared()
    paymentHandler.confirmPayment(intent, with: self) {(status , intent , error) in
        completion(status,intent,error)
    }
    
}

}
