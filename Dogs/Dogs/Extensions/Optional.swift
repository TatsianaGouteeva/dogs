//
//  Optional.swift
//  Dogs
//
//  Created by PC0002 on 25.07.22.
//

extension Optional where Wrapped == Double {
    var orZero: Double { self ?? .zero }
}

extension Optional where Wrapped == String {
    var orEmpty: Wrapped { self ?? "" }
}

extension Optional where Wrapped: Collection {
    var orEmpty: Wrapped { self ?? [] as! Wrapped }
}

extension Optional where Wrapped == Bool {
    var orFalse: Wrapped { self ?? false }
}
