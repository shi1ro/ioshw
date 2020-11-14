//
//  GoodsTableViewCell.swift
//  goodstracker
//
//  Created by njuios on 2020/11/14.
//

import UIKit

class GoodsTableViewCell: UITableViewCell {

    @IBOutlet weak var phiv: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var desclabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
