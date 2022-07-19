//
//  DescriptionDogCollectionViewCell.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 19.07.22.
//

import UIKit

final class DescriptionDogCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var breedLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func configure(model: DogDescription) {
        breedLabel.text = model.breed
        heightLabel.text = model.height
        weightLabel.text = model.weight
        descriptionLabel.text = model.description
    }
}
