//
//  SelectPackageContentViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 31/03/22.
//

import UIKit
import SwiftyJSON

class SelectPackageContentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var checkBox : Bool = false
    var arrSelectedRows :[Int] = []
    var packageContent = ["Documents | Books", "Clothes" , "Accessories", "Grocery","Food","Flowers","Household Items","Sports & Other Equipment", "Electronic Items","Others"]
    
    var packageText :[String] = []
    var packageItem :[Int] = []
    var packageArray :[JSON] = []
    var itemValue :[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        
    }

    func delegateMethod() {
        tableView.delegate = self
        tableView.dataSource = self
        proceedButton.layer.cornerRadius = 20
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return packageContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "package") as! PackageContentTableViewCell
        
        if arrSelectedRows.contains(indexPath.row)
        {
            //cell.checkBoxBtn.setImage(nil, for: .normal)
           cell.checkBoxBtn.setImage(UIImage(named:"Checked"), for: .normal)
           
        }
        else
        {
           cell.checkBoxBtn.setImage(UIImage(named:"UnChecked"), for: .normal)

        }
       cell.checkBoxBtn.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        
        cell.checkBoxBtn.tag = indexPath.row
        
        cell.packageLabel.text = packageContent[indexPath.row]
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70.0
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("sender.tag = ", indexPath.row)
        var testData = packageContent[indexPath.row]
        print("testData",testData)
        packageText.append(testData)
        
        if self.arrSelectedRows.contains(indexPath.row) {
            self.arrSelectedRows.remove(at: self.arrSelectedRows.firstIndex(of: indexPath.row)!)
            //packageArray.removeLast()

        } else {
            self.arrSelectedRows.append(indexPath.row)
        
        }
        self.tableView.reloadData()
        
    }
   

    @IBAction func proceedButton(_ sender: UIButton) {
        
        for controller in self.navigationController!.viewControllers  {
                if let deliveryPackage = controller as? DeliveryPackageViewController {
                       deliveryPackage.packageFood = packageText
                      deliveryPackage.packageFood = itemValue
                       self.navigationController?.popToViewController(deliveryPackage, animated: true)
                   }
          }
    }
    
    
    @objc func checkBoxSelection(_ sender: UIButton) {
        print("sender.tag = ", sender.tag)
        packageItem.append(sender.tag)
        
        if self.arrSelectedRows.contains(sender.tag) {
            self.arrSelectedRows.remove(at: self.arrSelectedRows.firstIndex(of: sender.tag)!)
        
        } else {
            self.arrSelectedRows.append(sender.tag)
            
        }
        print(arrSelectedRows)
        
        print(packageContent[sender.tag])
        itemValue.append(packageContent[sender.tag])
        
        self.tableView.reloadData()
    }
}
