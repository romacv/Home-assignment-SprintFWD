//
//  StudioCell.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 2/7/2022.
//

import UIKit

class StudioCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(item: Business) {
        var content = self.defaultContentConfiguration()
        content.image = UIImage(named: "fitness")
        content.text = item.name
        content.secondaryText = String(item.distance)
        content.textProperties.color = .black
        content.secondaryTextProperties.color = .darkGray
        self.contentConfiguration = content
    }

}
