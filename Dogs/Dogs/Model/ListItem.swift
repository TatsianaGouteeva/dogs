//
//  ListItem.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 25.07.22.
//

enum ListSection: CaseIterable {
    case list
}

struct ListItem: Hashable {
    var imageName: String
    var breed: String
}
