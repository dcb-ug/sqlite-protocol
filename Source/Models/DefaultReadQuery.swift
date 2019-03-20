//
//  DefaultReadQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultReadQuery<Model>: AnyReadQuery<Model> {}

extension DefaultReadQuery: DefaultReadQueryProviding where Model: Persistable {
    public typealias PrimaryKeyType = Model.Columns.PrimaryKeyType

    public static var first: DefaultReadQuery {
        return DefaultReadQuery { database in
            guard let row = try database.pluck(DefaultReadQuery.table) else { return nil }
            let schema = Model.Columns.from(row: row)
            return try Model(databaseRow: schema)
        }
    }

    public static func withPrimaryKey(_ key: Model.Columns.PrimaryKeyType) -> DefaultReadQuery {
        return DefaultReadQuery { database in
            let query = DefaultReadQuery.table.filter(Model.Columns.primaryKeySelector(value: key))
            guard let row = try database.pluck(query) else { return nil }
            let columns = Model.Columns.from(row: row)
            return try Model(databaseRow: columns)
        }
    }
}

extension DefaultReadQuery where Model: Sequence,
                                 Model: ContsructableFromArray,
                                 Model.Element: Persistable,
                                 Model.Element.ReadQuery: DefaultReadQueryProviding {
    public static var all: DefaultReadQuery {
        return DefaultReadQuery { database in
            let rows = try database.prepare(Model.Element.ReadQuery.table)
            let models = try rows.map { row -> Model.Element in
                let columns = Model.Element.Columns.from(row: row)
                return try Model.Element(databaseRow: columns)
            }
            return Model.init(models)
        }
    }
}
