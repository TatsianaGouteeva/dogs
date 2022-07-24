//
//  JSONLoader.swift
//  Dogs
//
//  Created by Inna Markevich on 23.07.22.
//

import Foundation
import UIKit

final class JSONLoader {

    static let shared = JSONLoader()
    
     func load(from fileName: String) -> [Dog]? {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: path)
            guard let dogsList = try? JSONDecoder().decode([Dog].self, from: data) else {
                return nil
            }
            return dogsList
        } catch {
            print(error)
        }
        return nil
    }
}
