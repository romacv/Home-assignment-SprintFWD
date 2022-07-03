//
//  StudioCell.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 2/7/2022.
//

import UIKit

class StudioCell: UITableViewCell {

    var rowIndex: Int = 0
    
    func setupCell(item: Business) {
        var content = self.defaultContentConfiguration()
        content.image = UIImage(named: "fitness")
        content.imageProperties.tintColor = tintColorForImage()
        content.text = item.name
        var secondaryText = ""
        if let price = item.price {
            secondaryText.append(contentsOf: price)
            secondaryText.append(contentsOf: " • ")
        }
        secondaryText.append(contentsOf: String.init(format: "%.2f miles",
                                                     item.distance.getMiles()))
        content.secondaryText = secondaryText
        content.textProperties.color = .black
        content.secondaryTextProperties.color = UIColor.lilacGrey
        self.contentConfiguration = content
    }
    
    private func tintColorForImage() -> UIColor {
        let isIndexValid = UIColor.gradientColors.indices.contains(rowIndex)
        if isIndexValid {
            return UIColor.gradientColors[rowIndex]
        }
        else {
            return UIColor.gradientColors.last ?? UIColor.black
        }
    }

}
