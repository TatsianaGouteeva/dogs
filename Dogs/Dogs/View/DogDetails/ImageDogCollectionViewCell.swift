//
//  ImageDogCollectionViewCell.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 19.07.22.
//

import UIKit

final class ImageDogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var dogImageView: UIImageView!
    
    func configure(image: String) {
        dogImageView.image = UIImage(named: image)
    }
}
