//
//  Dog.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 19.07.22.
//

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

extension Double {
    
    var orEmptyString: String {
        String(self)
    }
}
