//
//  DefaultReadQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultReadQuery<Model: Persistable>: ReadQueryProtocol {
    public typealias PrimaryKeyType = Model.Columns.PrimaryKeyType

    /// this is exposed like this so you can use it when building your own queries
    public static func _readFirst (using connection: Connection) throws -> [Model] {
        return try swallowNoSuchTableError {
            guard let row = try connection.pluck(DefaultReadQuery.table) else { return [] }
            let columns = Model.Columns.from(row: row)
            return try [Model(databaseColumns: columns)]
        }
    }

    /// this is exposed like this so you can use it when building your own queries
    public static func _read (withPrimaryKey key: Model.Columns.PrimaryKeyType,
                              using connection: Connection) throws -> [Model] {
        return try swallowNoSuchTableError {
            let query = DefaultReadQuery.table.filter(Model.Columns.primaryKeySelector(value: key))
            guard let row = try connection.pluck(query) else { return [] }
            let columns = Model.Columns.from(row: row)
            return try [Model(databaseColumns: columns)]
        }
    }

    /// this is exposed like this so you can use it when building your own queries
    public static func _readAll (using connection: Connection) throws -> [Model] {
        return try swallowNoSuchTableError {
            let rows = try connection.prepare(DefaultReadQuery.table)
            return try rows.map { row -> Model in
                let columns = Model.Columns.from(row: row)
                return try Model(databaseColumns: columns)
            }
        }
    }

    /// this is exposed like this so you can use it when building your own queries
    public static func swallowNoSuchTableError(function: () throws -> [Model]) rethrows -> [Model] {
        do {
            return try function()
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            return []
        }
    }

    public static var first: DefaultReadQuery {
        return DefaultReadQuery { connection in try _readFirst(using: connection) }
    }

    public static func withPrimaryKey(_ key: Model.Columns.PrimaryKeyType) -> DefaultReadQuery {
        return DefaultReadQuery { connection in try _read(withPrimaryKey: key, using: connection) }
    }

    public static var all: DefaultReadQuery {
        return DefaultReadQuery { connection in try _readAll(using: connection) }
    }

    private let block: (Connection) throws -> [Model]

    init(_ block: @escaping (Connection) throws -> [Model]) {
        self.block = block
    }

    public func run(using connection: Connection) throws -> [Model] {
        return try self.block(connection)
    }
}
