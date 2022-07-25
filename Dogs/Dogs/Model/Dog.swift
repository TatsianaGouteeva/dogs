//
//  Dog.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 19.07.22.
//

import RealmSwift

struct Dog: Decodable {
    let breed: String
    let height: Double?
    let weight: Double?
    let description: String?
    let images: [String]?
    
    var dictionary: [String : String] {
        return ["breed" : breed,
                "height" : height?.orEmptyString ?? "",
                "weight" : weight?.orEmptyString ?? "",
                "description" : description ?? ""]
    }
}

// MARK: Mapping

extension Dog {
    
    init(from model: DogObject) {
        self.init(breed: model.breed,
                  height: model.height,
                  weight: model.weight,
                  description: model.dogDescription,
                  images: model.images)
    }
}


extension Double {
    
    var orEmptyString: String {
        String(self)
    }
}
