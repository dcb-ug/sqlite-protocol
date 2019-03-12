//
//  ReadQueryProtocol.swift
//
//  Created by Manuel Reich on 12.03.19.
//

import SQLite

public protocol ReadQueryProtocol {
    associatedtype Model: PrimaryKeyProviding

    func run(fetchModelWith primaryKey: Model.PrimaryKeyType, from database: Connection) throws
}
