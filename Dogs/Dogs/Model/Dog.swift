//
//  Dog.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 19.07.22.
//

struct Dog {
    let breed: String
    let height: String
    let weight: String
    let description: String
    let images: [String]
    
    var dictionary: [String : String] {
        return ["breed" : breed,
                "height" : height,
                "weight" : weight,
                "description" : description]
    }
}
