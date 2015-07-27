//
//  ItemCell.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 7/5/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var authorIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let hex = hash % (0xff * 0xff * 0xff)
        contentImageView.backgroundColor = UIColor(hex: hex)

        authorIconImageView.image = UIImage(named: "icon")
        authorIconImageView.backgroundColor = UIColor(hex: 0xeeeeee)
    }

}
