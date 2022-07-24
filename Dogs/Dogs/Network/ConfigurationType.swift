//
//  ConfigurationType.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 20.07.22.
//

enum NetworkConfigurationType: String {
    case mock
}

enum ConcurrencyConfigurationType: String {
    case gcd
    case operation
    case asyncAwait
}

enum DatabaseConfigurationType: String {
    case coredata
    case firebase
    case realm
}
