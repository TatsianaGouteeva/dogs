//
//  DogDetailsViewModel.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 20.07.22.
//

import UIKit

final class DogDetailsViewModel {
    
    private let dog: Dog
    private var imagePresentation: ImagePresentation = .collage
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>
    
    var snapshot: ((Snapshot) -> ())?
    var sectionTypeSwitcherHeader: ((String) -> ())?
    
    init(dog: Dog) {
        self.dog = dog
    }
    
    func fetchData() {
        snapshot?(getDogDetails())
        sectionTypeSwitcherHeader?(imagePresentation.sectionTypeSwitcherHeader)
    }
    
    func changeImagePresentation() {
        self.imagePresentation = imagePresentation == .collage ? .list : .collage
        
        snapshot?(getDogDetails())
        sectionTypeSwitcherHeader?(imagePresentation.sectionTypeSwitcherHeader)
    }
    
    private func getDogDetails() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([(imagePresentation == .collage ? .collage : .imageList)])
        snapshot.appendItems(dog.images.map { Item.image($0) })
        
        snapshot.appendSections([.description])
        snapshot.appendItems([.dog(.init(breed: dog.breed,
                                         height: dog.height,
                                         weight: dog.weight,
                                         description: dog.description))], toSection: .description)
        
        return snapshot
    }
}