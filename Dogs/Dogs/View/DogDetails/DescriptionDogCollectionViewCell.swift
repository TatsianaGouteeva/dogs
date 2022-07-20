//
//  DescriptionDogCollectionViewCell.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 19.07.22.
//

import UIKit

final class DescriptionDogCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func configure(titleLabel: String, valueLabel: String) {
        self.titleLabel.text = titleLabel
        self.valueLabel.text = valueLabel
    }
}
