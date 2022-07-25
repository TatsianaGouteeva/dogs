//  DogListViewModel.swift
//  Dogs
//
//  Created by Inna Markevich on 20.07.22.
//

import Foundation
import UIKit

final class DogsListViewModel {

    typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>
    
    private let databaseService = DatabaseService()
    var dogs: [Dog] = [Dog]()
    
    var didSelectDog: ((Dog) -> Void)?
    var snapshot: ((Snapshot) -> ())?
    
    // MARK: - Fetch data from Database

    func updateData () {
        dogs = databaseService.fetchData()
    }

    // MARK: - Data source

    func applyData() {
        snapshot?(fillDogsList())
    }

    func cellSelected(for index: Int) {
        didSelectDog?(dogs[index])
    }

    private func fillDogsList() -> Snapshot {
        let list = dogs.map { ListItem(imageName: ($0.images?.first).orEmpty, breed: $0.breed) }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(list, toSection: .list)
        return snapshot
    }
}
