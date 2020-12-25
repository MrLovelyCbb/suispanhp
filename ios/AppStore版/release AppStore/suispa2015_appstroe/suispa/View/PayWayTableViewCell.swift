//
//  PayWayTableViewCell.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/11.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class PayWayTableViewCell: UITableViewCell {

    @IBOutlet weak var myPayWayImage: UIImageView!
    @IBOutlet weak var myPayWayTitle: UILabel!
    @IBOutlet weak var myPayWayDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
