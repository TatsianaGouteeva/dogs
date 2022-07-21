//
//  MockNetworkConfiguration.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 20.07.22.
//

import Foundation

struct MockNetworkConfiguration: NetworkConfiguration {
    var baseURL: URL = Bundle.main.bundleURL
    var commonHeaders: [String: String] = [:]
}
