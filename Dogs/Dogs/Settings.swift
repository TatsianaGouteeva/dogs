//
//  Settings.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 20.07.22.
//

import Foundation

final class Settings {

    private(set) var activeNetworkConfiguration: NetworkConfiguration
    private(set) var activeConcurrencyConfiguration: ConcurrencyConfigurationType
    
    private(set) static var shared = Settings()

    private enum Keys {
        static let activeNetworkConfiguration = "ActiveNetworkConfiguration"
        static let activeConcurrencyConfiguration = "ActiveConcurrencyConfiguration"
    }

    private init() {
        activeNetworkConfiguration = MockNetworkConfiguration()
        activeConcurrencyConfiguration = ConcurrencyConfigurationType.gcd
        
        if let configuration = UserDefaults.standard.string(forKey:
            Keys.activeNetworkConfiguration),
            let configurationType = NetworkConfigurationType(rawValue: configuration) {
            activeNetworkConfiguration = networkConfiguration(of: configurationType)
        } else {
            UserDefaults.standard.set(NetworkConfigurationType.mock.rawValue,
                                      forKey: Keys.activeNetworkConfiguration)
        }
        
        if let configuration = UserDefaults.standard.string(forKey:
                                                                Keys.activeConcurrencyConfiguration),
           let configurationType = ConcurrencyConfigurationType(rawValue: configuration) {
            activeConcurrencyConfiguration = configurationType
        } else {
            UserDefaults.standard.set(ConcurrencyConfigurationType.gcd.rawValue,
                                      forKey: Keys.activeConcurrencyConfiguration)
        }
    }
    
    private func networkConfiguration(of type: NetworkConfigurationType) -> NetworkConfiguration {
        switch type {
        case .mock:
            return MockNetworkConfiguration()
        }
    }
}
