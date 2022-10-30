//
//  AnyWriteQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

/// Subclass this if you want to write your own custom write queries
open class AnyWriteQuery<Model> {

    private let block: (Model, Connection) throws -> Void

    public init(block: @escaping (Model, Connection) throws -> Void) {
        self.block = block
    }

    public func run(persisting model: Model, using connection: Connection) throws {
        try self.block(model, connection)
    }
}
