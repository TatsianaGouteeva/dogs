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


    //private let service: NetworkService = NetworkService(networkConfiguration: Settings.shared.activeNetworkConfiguration)

    init() {
        fetchDogs()
    }

    func fetchDogs() {
        //  service.request(apiEndpoint: APIEndpoints.getDogs(with: [:], queryParameters: [:])) { result in
        //         DispatchQueue.main.async {
        //                        switch result {
        //                        case .failure:
        //                            print("Error")
        //            case let .success(data):
        //                            for elt in data {
        //                                list.append(DogDetailsViewModel(id: elt.description, name: elt.breed))
        //                            }
        dogs = [Dog(breed: "Akita", height: "28 inches", weight: "80 pounds", description: "Akita is muscular, double-coated dogs of ancient Japanese lineage famous for her dignity, courage, and loyalty. In her native land, she's venerated as family protectors and symbols of good health, happiness, and long life.", images: ["foto1", "foto2", "foto3", "foto4"]),
                Dog(breed: "Akita1", height: "28 inches", weight: "80 pounds", description: "Akita is muscular, double-coated dogs of ancient Japanese lineage famous for her dignity, courage, and loyalty. In her native land, she's venerated as family protectors and symbols of good health, happiness, and long life.", images: ["foto1", "foto2", "foto3", "foto4"]),
                Dog(breed: "Akita2", height: "28 inches", weight: "80 pounds", description: "Akita is muscular, double-coated dogs of ancient Japanese lineage famous for her dignity, courage, and loyalty. In her native land, she's venerated as family protectors and symbols of good health, happiness, and long life.", images: ["foto1", "foto2", "foto3", "foto4"])]
        list = dogs.map { dog in
            ListItem(imageName: dog.images[0], breed: dog.breed)
        }
        //   }
        // }
        // }
    }

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
