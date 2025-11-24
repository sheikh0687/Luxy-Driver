//
//  EarningCell.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 15/12/23.
//

import UIKit
import Cosmos

class EarningCell: UITableViewCell {

    @IBOutlet weak var lbl_PickAddress: UILabel!
    @IBOutlet weak var lbl_DropAddress: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var lbl_Feedback: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
