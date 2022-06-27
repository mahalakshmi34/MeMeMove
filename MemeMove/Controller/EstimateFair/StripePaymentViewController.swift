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
    var transcationType = 0
    var transcationID = ""
    var userPay = 0.0
    var orderID :Int = 0
    var orderName = ""
    var flatNumber = ""
    var fromCity = ""
    var fromState = ""
    var fromCountry = ""
    var pickUpLatitude = 0.0
    var pickUpLongitude = 0.0
    var frontImage = ""
    var backImage = ""
    var dateString = ""
    var userID = ""
    var username = ""
    var userphoneno = ""
    var vehicleType = ""
    var driverId = 0
    var driverName = ""
    var driverPhoneNumber = ""
    var driverPay = 0.0
    var toCity = ""
    var toCountry = ""
    var toState = ""
    var toName = ""
    var toPhoneNumber = ""
    var dropLatiutde = 0.0
    var dropLongitude = 0.0
    var deliveryStatus = ""

  
    
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
                               self.transcationStatus = "failed"
                               self.displayAlert(title: "Payment failed", message: "Failed")
                           // UserDefaults.standard.set(transcationStatus, forKey: "transcationStatus")
                               break
                           case .canceled:
                               resultString = "Payment failed"
                               self.transcationStatus = "failed"
                               self.displayAlert(title: "Payment canceled", message: "failed")
//                               transcationStatus = "false"
//                            UserDefaults.standard.set(transcationStatus, forKey: "transcationStatus")
                               break
                           case .succeeded:
                               
                            resultString = "Payment Sucess"
                               self.transcationStatus = "succeeded"
                             
                               UserDefaults.standard.removeObject(forKey: "payAmount")
           
                            let alert = UIAlertController(title: "Payment Sucess", message: "Sucess", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: {_ in
                                ProgressHUD.dismiss()

                              let homeVC = self.storyboard?.instantiateViewController(identifier: "WaitingViewController") as! WaitingViewController
                               self.navigationController?.pushViewController(homeVC, animated: true)
                            }))
                            // updateDeposit(Status : transcationStatus)
                            self.present(alert, animated: true, completion: nil)
                               
                               print(paymentIntent?.status)
                            
                            transcationID = paymentIntent!.stripeId
                            UserDefaults.standard.set(transcationID, forKey: "transcationID")
                               

                            print(paymentIntent?.status)
                            print(paymentIntent?.stripeId)
                               
                               
                               
                            confirmOrder()
                               
                           break
                           
                           @unknown default:
                               fatalError()
                               break
                         }
            }
        }
       // var cardSave = cardTextField.text
            
      }
    
    func todaysDate() {
        
            var startDate = ""
            var endDate  = ""
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let now = Date()
            dateString = formatter.string(from:now)
            print(dateString)
    }
    
    func confirmOrder() {
        
        
        if UserDefaults.standard.string(forKey: "transcationID") != nil {
            transcationID = UserDefaults.standard.string(forKey: "transcationID")!
        }
        
        if UserDefaults.standard.string(forKey: "transcationStatus") != nil {
            transcationStatus = UserDefaults.standard.string(forKey: "transcationStatus")!
        }
        
        if UserDefaults.standard.integer(forKey: "orderID") != nil {
            orderID = UserDefaults.standard.integer(forKey: "orderID")
            print(orderID)
        }
        
        if UserDefaults.standard.string(forKey: "orderName") != nil {
            orderName = UserDefaults.standard.string(forKey: "orderName")!
        }
        
        if UserDefaults.standard.string(forKey: "flatNumber") != nil {
            flatNumber = UserDefaults.standard.string(forKey: "flatNumber")!
        }
        
        if  UserDefaults.standard.string(forKey: "fromCity") != nil {
            fromCity = UserDefaults.standard.string(forKey: "fromCity")!
        }
        
        if UserDefaults.standard.string(forKey: "fromCountry") != nil {
            fromCountry = UserDefaults.standard.string(forKey: "fromCountry")!
        }
        
        if UserDefaults.standard.string(forKey: "fromState") != nil {
            fromState = UserDefaults.standard.string(forKey: "fromState")!
        }
        
        if UserDefaults.standard.double(forKey: "pickUpLatitude") != nil {
            pickUpLatitude = UserDefaults.standard.double(forKey: "pickUpLatitude")
        }
        
        if  UserDefaults.standard.double(forKey: "pickUpLongitude") != nil {
            pickUpLongitude = UserDefaults.standard.double(forKey: "pickUpLongitude")
        }
        
        if UserDefaults.standard.string(forKey: "frontImage") != nil {
            frontImage = UserDefaults.standard.string(forKey: "frontImage")!
        }
        
        if UserDefaults.standard.string(forKey: "backImage") != nil {
            backImage = UserDefaults.standard.string(forKey: "backImage")!
        }
        
        if UserDefaults.standard.string(forKey: "userID") != nil {
            userID = UserDefaults.standard.string(forKey: "userID")!
        }
        
        if UserDefaults.standard.string(forKey: "username") != nil {
            username = UserDefaults.standard.string(forKey: "username")!
        }
        
        if UserDefaults.standard.string(forKey: "userphoneno") != nil {
            userphoneno = UserDefaults.standard.string(forKey: "userphoneno")!
        }
        
        if UserDefaults.standard.string(forKey: "vehicleType") != nil {
            vehicleType = UserDefaults.standard.string(forKey: "vehicleType")!
        }
        
        if UserDefaults.standard.integer(forKey: "driverid") != nil {
            driverId = UserDefaults.standard.integer(forKey: "driverid")
        }
        
        if UserDefaults.standard.string(forKey: "drivername") != nil {
            driverName = UserDefaults.standard.string(forKey: "drivername")!
        }
        
        if UserDefaults.standard.string(forKey: "driverphoneno") != nil {
            driverPhoneNumber = UserDefaults.standard.string(forKey: "driverphoneno")!
        }
        
        
        if UserDefaults.standard.double(forKey: "driverPay") != nil {
            driverPay = UserDefaults.standard.double(forKey: "driverPay")
        }
        
        if UserDefaults.standard.string(forKey: "toCity") != nil {
            toCity = UserDefaults.standard.string(forKey: "toCity")!
        }
        
        if UserDefaults.standard.string(forKey: "toCountry") != nil {
            toCountry = UserDefaults.standard.string(forKey: "toCountry")!
        }
        
        if UserDefaults.standard.string(forKey: "toState") != nil {
            toState = UserDefaults.standard.string(forKey: "toState")!
        }
        
        if UserDefaults.standard.string(forKey: "toName") != nil {
            toName = UserDefaults.standard.string(forKey: "toName")!
        }
        
        if UserDefaults.standard.string(forKey: "tophoneno") != nil {
            toPhoneNumber = UserDefaults.standard.string(forKey: "tophoneno")!
        }
        
        if UserDefaults.standard.double(forKey: "dropLatitude") != nil {
           dropLatiutde = UserDefaults.standard.double(forKey: "dropLatitude")
        }
        
        if UserDefaults.standard.double(forKey: "dropLongitude") != nil {
           dropLatiutde = UserDefaults.standard.double(forKey: "dropLongitude")
        }
        
        if UserDefaults.standard.string(forKey: "deliveryStatus") != nil {
            deliveryStatus = UserDefaults.standard.string(forKey: "deliveryStatus")!
        }
        
        
let url = "https://api.mememove.com:8443/MeMeMove/Order/add/Confirm/Order?orderid=\(orderID)&ordername=\(orderName)&flatno=\(flatNumber)&city=\(fromCity)&state=\(fromState)&country=\(fromCountry)&fromlat=\(pickUpLatitude)&fromlong=\(pickUpLongitude)&deliverytype=FAST&orderimg=\(frontImage)&orderimgtopview=\(backImage)&orderdate=\(dateString)&userid=\(userID)&username=\(username)&userphoneno=\(userphoneno)&userpay=\(userPay)&driverid=\(driverId)&drivername=\(driverName)&driverphoneno=\(driverPhoneNumber)&driverpay=\(driverPay)&toflatno=\(flatNumber)&tocity=\(toCity)&tostate=\(toState)&tocountry=\(toCountry)&tophoneno=\(toPhoneNumber)&tolat=\(dropLatiutde)&tolong=\(dropLongitude)&deliverystatus=\(deliveryStatus)&paymentstatus=\(transcationStatus)&transactionid=\(transcationID)"
        
        print(url)
        
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default,headers: header)
            .responseJSON { [self] response in
                print("isiLagi: \(response)")
                switch response.result {
                case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                    print(json)
                    
                    if let orderId = json["orderid"].string {
                        orderID = Int(orderId)!
                        print(orderID)
                       // UserDefaults.standard.set(orderID, forKey: "confirmOrderId")
                        
                        UserDefaults.standard.set(orderID, forKey: "confirmOrderId")
                    }
                    
                    passOrder()
                   
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    }
                }
        
    }
    
    func passOrder() {
        
        var orderByID = 0
        
        if UserDefaults.standard.string(forKey: "confirmOrderId") != nil {
        
          UserDefaults.standard.string(forKey: "confirmOrderId")
            
            print(UserDefaults.standard.string(forKey: "confirmOrderId"))
        
           
        }
        
        if UserDefaults.standard.string(forKey: "deliveryStatus") != nil {
            deliveryStatus = UserDefaults.standard.string(forKey: "deliveryStatus")!
            print(deliveryStatus)
        }
        
        let url = "http://e-bikefleet.com:5002/post/order"
        print(url)
        
        let parameter : Parameters = [
            "orderid" : UserDefaults.standard.string(forKey: "confirmOrderId"),
            "orderstatus" : deliveryStatus
        ]
        print(parameter)
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default,headers: header)
            .responseJSON { [self] response in
                print("isiLagi: \(response)")
                switch response.result {
                case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                    print(json)
                   
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    }
                }
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
