//
//  Dog.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 19.07.22.
//
import Foundation
//import RealmSwift

struct Dog {
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
    
//    init(from model: DogObject) {
//        self.init(breed: model.breed,
//                  height: model.height,
//                  weight: model.weight,
//                  description: model.dogDescription,
//                  images: model.images)
//    }

    init(from model: DogEntity) {
        self.init(breed: model.breed,
                  height: model.height,
                  weight: model.weight,
                  description: model.description,
                  images: model.images)
    }
}

extension Double {
    
    var orEmptyString: String {
        String(self)
    }
}

extension Dog: Codable {
    enum CodingKeys: CodingKey {
        case breed, height, weight, description, images
    }

    var firebaseDictionary: [String: Any]? {
       guard let data = try? JSONEncoder().encode(self) else { return nil }
       return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .map { $0 as? [String: Any] ?? [:] }
     }
}
