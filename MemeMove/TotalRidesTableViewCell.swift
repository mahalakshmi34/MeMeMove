    //
//  TotalRidesTableViewCell.swift
//  MemeMove
//
//  Created by Vijay Raj on 09/07/22.
//

import UIKit

class TotalRidesTableViewCell: UITableViewCell {
    
    @IBOutlet var fromRoad: UILabel!
    @IBOutlet var toRoad: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var labelLine: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var onGoingUpdate: UILabel!
    
    @IBOutlet var dateUpdate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
