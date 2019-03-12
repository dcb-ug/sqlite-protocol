//
//  ReadQueryProtocol.swift
//
//  Created by Manuel Reich on 12.03.19.
//

import SQLite

public protocol ReadQueryProtocol {
    associatedtype Model

    func run(read filter: Expression<Bool>, from database: Connection) throws -> Model
}

extension ReadQueryProtocol where Model: PrimaryKeyProviding {
    func run(fetchModelWith primaryKey: Model.PrimaryKeyType, from database: Connection) throws -> Model {
        let filter = Model.primaryKey == primaryKey
        return try run(read: filter, from: database)
    }
}
