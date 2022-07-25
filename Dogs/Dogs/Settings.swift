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
    private(set) var activeDatabaseConfiguration: DatabaseServiceProtocol
    
    private(set) static var shared = Settings()

    private enum Keys {
        static let activeNetworkConfiguration = "ActiveNetworkConfiguration"
        static let activeConcurrencyConfiguration = "ActiveConcurrencyConfiguration"
        static let activeDatabaseConfiguration = "ActiveDatabaseConfiguration"
    }

    private init() {
        activeNetworkConfiguration = MockNetworkConfiguration()
        activeConcurrencyConfiguration = ConcurrencyConfigurationType.gcd
        activeDatabaseConfiguration = CoreDataStack(modelName: "Dogs")
        
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
            activeDatabaseConfiguration = databaseConfiguration(of: configurationType)
        } else {
            UserDefaults.standard.set(DatabaseConfigurationType.coredata.rawValue,
                                      forKey: Keys.activeDatabaseConfiguration)
        }
    }
    
    func activateDatabaseConfiguration(of type: DatabaseConfigurationType) {
        UserDefaults.standard.set(type.rawValue,
                                  forKey: Keys.activeDatabaseConfiguration)
        activeDatabaseConfiguration = databaseConfiguration(of: type)
    }
}

private extension Settings {
    
    func networkConfiguration(of type: NetworkConfigurationType) -> NetworkConfiguration {
        switch type {
        case .mock:
            return MockNetworkConfiguration()
        }
    }
    
    func databaseConfiguration(of type: DatabaseConfigurationType) -> DatabaseServiceProtocol {
        switch type {
        case .coredata:
            return CoreDataStack(modelName: "Dogs")
        case .realm:
            return RealmDataManager()
        case .firebase:
            return RealmDataManager()
        }
    }
}
