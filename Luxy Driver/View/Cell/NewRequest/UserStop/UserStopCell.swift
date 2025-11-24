//
//  UserStopCell.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 11/12/24.
//

import UIKit

class UserStopCell: UITableViewCell {

    @IBOutlet weak var lbl_StopAddress: UILabel!
    @IBOutlet weak var button_Vw: UIView!
    @IBOutlet weak var btn_ConfirmMoveOt: UIButton!
    
    var clo_ConfirmToMove: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_ConfirmToMove(_ sender: UIButton) {
        self.clo_ConfirmToMove?()
    }
}
