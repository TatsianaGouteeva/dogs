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
       // snapshot.appendItems(dog.images.map { Item.image($0) })
        
        snapshot.appendSections([.description])
        let descriptionItems = dog.dictionary
            .filter { !$0.value.isEmpty }
            .sorted(by: { $0.key < $1.key })
            .map { Item.dog($0, $1) }
        snapshot.appendItems(descriptionItems, toSection: .description)
        
        return snapshot
    }
}
