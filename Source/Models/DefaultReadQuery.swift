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
        return DefaultReadQuery { database in
            guard let row = try database.pluck(DefaultReadQuery.table) else { return [] }
            let columns = Model.Columns.from(row: row)
            return try [Model(databaseColumns: columns)]
        }
    }

    public static func withPrimaryKey(_ key: Model.Columns.PrimaryKeyType) -> DefaultReadQuery {
        return DefaultReadQuery { database in
            let query = DefaultReadQuery.table.filter(Model.Columns.primaryKeySelector(value: key))
            guard let row = try database.pluck(query) else { return [] }
            let columns = Model.Columns.from(row: row)
            return try [Model(databaseColumns: columns)]
        }
    }

    public static var all: DefaultReadQuery {
        return DefaultReadQuery { database in
            let rows = try database.prepare(DefaultReadQuery.table)
            return try rows.map { row -> Model in
                let columns = Model.Columns.from(row: row)
                return try Model(databaseColumns: columns)
            }
        }
    }
}
