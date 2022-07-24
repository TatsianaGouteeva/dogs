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
    var activeDatabaseConfiguration: DatabaseConfigurationType
    
    private(set) static var shared = Settings()

    private enum Keys {
        static let activeNetworkConfiguration = "ActiveNetworkConfiguration"
        static let activeConcurrencyConfiguration = "ActiveConcurrencyConfiguration"
        static let activeDatabaseConfiguration = "ActiveDatabaseConfiguration"
    }

    private init() {
        activeNetworkConfiguration = MockNetworkConfiguration()
        activeConcurrencyConfiguration = ConcurrencyConfigurationType.gcd
        activeDatabaseConfiguration = DatabaseConfigurationType.coredata
        
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

        if let configuration = UserDefaults.standard.string(forKey:
                                                                Keys.activeDatabaseConfiguration),
           let configurationType = DatabaseConfigurationType(rawValue: configuration) {
            activeDatabaseConfiguration = configurationType
        } else {
            UserDefaults.standard.set(DatabaseConfigurationType.coredata.rawValue,
                                      forKey: Keys.activeDatabaseConfiguration)
        }
    }
    
    private func networkConfiguration(of type: NetworkConfigurationType) -> NetworkConfiguration {
        switch type {
        case .mock:
            return MockNetworkConfiguration()
        }
    }
}
