//
//  DogObject.swift
//  Dogs
//
//  Created by PC0002 on 25.07.22.
//

import RealmSwift

final class DogObject: Object {
    @objc dynamic var breed: String
    @objc dynamic var height: Double
    @objc dynamic var weight: Double
    @objc dynamic var dogDescription: String
    dynamic var images: [String]
    
    init(from model: Dog) {
        self.breed = model.breed
        self.height = model.height.orZero
        self.weight = model.weight.orZero
        self.dogDescription = model.description.orEmpty
        self.images = model.images.orEmpty
    }
}

