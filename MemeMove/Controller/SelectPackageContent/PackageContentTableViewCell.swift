//
//  PackageContentTableViewCell.swift
//  MemeMove
//
//  Created by Vijay Raj on 12/05/22.
//

import UIKit

class PackageContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.checkBoxBtn.addTarget(self, action: #selector(subscribeButtonTapped(_:)), for: .touchUpInside)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
