//
//  ProductCategoryCollectionCell.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import UIKit

class ProductCategoryCollectionCell: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    var onSelectSeeAll: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.layer.cornerRadius = 12
        imgBanner.layer.cornerRadius = 12
        viewBack.dropShadow()
    }
    @IBAction func btnSeeAll(_ sender: Any) {
        onSelectSeeAll!()
    }
}
