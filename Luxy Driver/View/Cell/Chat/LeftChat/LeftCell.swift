//
//  LeftCell.swift
//  kargo Buffalo Driver
//
//  Created by Techimmense Software Solutions on 08/11/23.
//

import UIKit

class LeftCell: UITableViewCell {

    @IBOutlet var lblDateAndTime: UILabel!
    @IBOutlet var textMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
