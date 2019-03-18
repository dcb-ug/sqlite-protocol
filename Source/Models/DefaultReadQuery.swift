//
//  DefaultReadQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultReadQuery<Model>: AnyReadQuery<Model> {}

extension DefaultReadQuery: DefaultReadQueryProviding where Model: Persistable & PrimaryKeyProviding {
    public typealias PrimaryKeyType = Model.PrimaryKeyType

    public static var first: DefaultReadQuery {
        return DefaultReadQuery { database in
            guard let row = try database.pluck(Model.table) else { return nil }
            return try Model(databaseRow: row)
        }
    }

    public static func withPrimaryKey(_ key: Model.PrimaryKeyType) -> DefaultReadQuery {
        return DefaultReadQuery { database in
            let query = Model.table.filter(Model.primaryKey == key)
            guard let row = try database.pluck(query) else { return nil }
            return try Model(databaseRow: row)
        }
    }
}

extension DefaultReadQuery where Model: Sequence,
                                 Model: ContsructableFromArray,
                                 Model.Element: Persistable {
    public static var all: DefaultReadQuery {
        return DefaultReadQuery { database in
            let rows = try database.prepare(Model.Element.table)
            let models = try rows.map { try Model.Element(databaseRow: $0) }
            return Model.init(models)
        }
    }
}
