//
//  DefaultReadQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultReadQuery<Model>: AnyReadQuery<Model> {}

extension DefaultReadQuery: DefaultReadQueryProviding where Model: Persistable {
    public typealias PrimaryKeyType = Model.Schema.PrimaryKeyType

    public static var first: DefaultReadQuery {
        return DefaultReadQuery { database in
            guard let row = try database.pluck(Model.Schema.table) else { return nil }
            let schema = Model.Schema.from(row: row)
            return try Model(databaseRow: schema)
        }
    }

    public static func withPrimaryKey(_ key: Model.Schema.PrimaryKeyType) -> DefaultReadQuery {
        return DefaultReadQuery { database in
            let query = Model.Schema.table.filter(Model.Schema.primaryKeySelector(value: key))
            guard let row = try database.pluck(query) else { return nil }
            let schema = Model.Schema.from(row: row)
            return try Model(databaseRow: schema)
        }
    }
}

extension DefaultReadQuery where Model: Sequence,
                                 Model: ContsructableFromArray,
                                 Model.Element: Persistable {
    public static var all: DefaultReadQuery {
        return DefaultReadQuery { database in
            let rows = try database.prepare(Model.Element.Schema.table)
            let models = try rows.map { row -> Model.Element in
                let schema = Model.Element.Schema.from(row: row)
                return try Model.Element(databaseRow: schema)
            }
            return Model.init(models)
        }
    }
}
