//
//  SavedCarCell.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import UIKit

class SavedCarCell: UITableViewCell {
    
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var lbl_CarDetails: UILabel!
    
    var closureDeleteCar: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btn_DeleteCar(_ sender: UIButton) {
        self.closureDeleteCar?()
    }
}
