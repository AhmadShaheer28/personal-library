//
//  BookTableViewCell.swift
//  Personal Library
//
//  Created on 12/12/2023.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var publicationLbl: UILabel!
    @IBOutlet weak var synopsisLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
