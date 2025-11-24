//
//  ReasonListCell.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 12/12/24.
//

import UIKit

class ReasonListCell: UITableViewCell {

    @IBOutlet weak var lbl_Reason: UILabel!
    @IBOutlet weak var check_Img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
