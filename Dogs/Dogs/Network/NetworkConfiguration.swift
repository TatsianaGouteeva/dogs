//
//  NetworkConfiguration.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 20.07.22.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol NetworkConfiguration {
    var baseURL: URL { get }
    var commonHeaders: HTTPHeaders { get }
}
