//
//  DatabaseQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public protocol DatabaseQuery {
    associatedtype Model

    func run(persisting model: Model, inside database: Connection) throws
}
