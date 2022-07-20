//
//  DogDetailsViewModel.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 20.07.22.
//

import UIKit

final class DogDetailsViewModel {
    
    private let dog: Dog
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>
    
    var snapshot: Snapshot { getDogDetails() }
    var didChangedImagePresentation: ((ImagePresentation) -> Void)?
    
    init(dog: Dog) {
        self.dog = dog
    }
    
    func changeImagePresentation(imagePresentation: ImagePresentation) {
        didChangedImagePresentation?(imagePresentation)
    }
    
    private func getDogDetails() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.collage])
        snapshot.appendItems(dog.images.map { Item.image($0) }, toSection: .collage)
        
        snapshot.appendSections([.description])
        snapshot.appendItems([.dog(.init(breed: dog.breed,
                                         height: dog.height,
                                         weight: dog.weight,
                                         description: dog.description))], toSection: .description)
        
        return snapshot
    }
}
