//  Created by TCode on 24/01/2021.

import Foundation
import UIKit

class StockCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!

    public func configure(stock: StockPrice) {
        nameLabel.text = stock.title
        priceLabel.text = "\(stock.price)"
        favoriteImageView.isHidden = !stock.isFavorite
    }
}
