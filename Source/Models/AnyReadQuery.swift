//
//  AnyReadQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

/// Subclass this if you want to write your own custom read queries
open class AnyReadQuery<Model> {

    private let block: (Connection) throws -> [Model]

    public init(block: @escaping (Connection) throws -> [Model]) {
        self.block = block
    }

    public func run(using connection: Connection) throws -> [Model] {
        return try self.block(connection)
    }
}
