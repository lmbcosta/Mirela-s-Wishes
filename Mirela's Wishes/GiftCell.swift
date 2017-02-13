//
//  GiftCell.swift
//  Mirela's Wishes
//
//  Created by Luis  Costa on 07/02/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class GiftCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var giftName: UILabel!
    @IBOutlet weak var giftPrice: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func updateCell(gift: Gift) {
        // update data
        giftName.text = gift.title!
        giftPrice.text = String(gift.price)
        details.text = gift.details
        if let image = gift.photo?.photo as? UIImage {
            self.photo.image = image
        }
    }
}
