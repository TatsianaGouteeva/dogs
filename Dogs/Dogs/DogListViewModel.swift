//  DogListViewModel.swift
//  Dogs
//
//  Created by Inna Markevich on 20.07.22.
//

import Foundation
import UIKit

final class DogsListViewModel {

    var dogs: [Dog] = [Dog]()
    var list: [ListItem] = [ListItem]()
    var didSelectDog: ((Dog) -> Void)?
    typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>
    private var databaseService = DatabaseService()

    // MARK: - Fetch data from Database

    func updateData () {
        dogs = databaseService.fetchData()
        list = dogs.map { dog in
            ListItem(imageName: "dog", breed: dog.breed)
        }
    }

    // MARK: - Data source

    var snapshot: ((Snapshot) -> ())?

    func applyData() {
        snapshot?(fillDogsList())
    }

    func cellSelected(for index: Int) {
        didSelectDog?(dogs[index])
    }

    private func fillDogsList() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(list, toSection: .list)
        return snapshot
    }
}
