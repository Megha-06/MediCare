//
//  ProductListingTableCell.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import UIKit

class ProductListingTableCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBuyNow: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.layer.cornerRadius = 12
        viewBack.dropShadow()
        btnBuyNow.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
