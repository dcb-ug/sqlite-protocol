//
//  DefaultReadQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultReadQuery<Model: Persistable>: AnyReadQuery<Model> {
    public typealias PrimaryKeyType = Model.Columns.PrimaryKeyType

    public static var first: DefaultReadQuery {
        return DefaultReadQuery { connection in
            guard let row = try connection.pluck(DefaultReadQuery.table) else { return [] }
            let columns = Model.Columns.from(row: row)
            return try [Model(databaseColumns: columns)]
        }
    }

    public static func withPrimaryKey(_ key: Model.Columns.PrimaryKeyType) -> DefaultReadQuery {
        return DefaultReadQuery { connection in
            let query = DefaultReadQuery.table.filter(Model.Columns.primaryKeySelector(value: key))
            guard let row = try connection.pluck(query) else { return [] }
            let columns = Model.Columns.from(row: row)
            return try [Model(databaseColumns: columns)]
        }
    }

    public static var all: DefaultReadQuery {
        return DefaultReadQuery { connection in
            let rows = try connection.prepare(DefaultReadQuery.table)
            return try rows.map { row -> Model in
                let columns = Model.Columns.from(row: row)
                return try Model(databaseColumns: columns)
            }
        }
    }
}
