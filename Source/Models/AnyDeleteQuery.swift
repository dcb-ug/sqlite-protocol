//
//  AnyDeleteQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

/// Subclass this if you want to write your own custom delete queries
open class AnyDeleteQuery<Model> {

    private let block: (Connection) throws -> Void

    public init(block: @escaping (Connection) throws -> Void) {
        self.block = block
    }

    public func run(using connection: Connection) throws {
        return try self.block(connection)
    }
}
