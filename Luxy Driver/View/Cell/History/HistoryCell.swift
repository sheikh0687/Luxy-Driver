//
//  HistoryCell.swift
//  kargo Buffalo Driver
//
//  Created by Techimmense Software Solutions on 18/10/23.
//

import UIKit
import Cosmos

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lblCancelled: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDropAddress: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var vwCosmos: CosmosView!
    @IBOutlet weak var btnRatingOt: UIButton!
    @IBOutlet weak var vwRating: UIView!
    
    var cloRating: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnGiveRating(_ sender: UIButton) {
        self.cloRating?()
    }
}
