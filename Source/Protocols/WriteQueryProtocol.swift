//
//  WriteQueryProtocol.swift
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public protocol WriteQueryProtocol {
    associatedtype Model

    func run(persisting model: Model, inside database: Connection) throws
    func createTableIfNotExists(inside database: Connection) throws
}
