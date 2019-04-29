//
//  DefaultWriteQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultDeleteQuery<Model: Persistable>: DeleteQueryProtocol {

    /// this is exposed like this so you can use it when building your own queries
    public static func _delete(wherePrimaryKey primaryKey: Model.Columns.PrimaryKeyType, connection: Connection) throws {
        let primaryKeySelector = Model.Columns.primaryKeySelector(value: primaryKey)
        let query = DefaultDeleteQuery.table.filter(primaryKeySelector)
        try connection.run(query.delete())
    }

    /// this is exposed like this so you can use it when building your own queries
    public static func _delete(wherePrimaryKeys primaryKeys: [Model.Columns.PrimaryKeyType], connection: Connection) throws {
        let primaryKeyExpression = Expression<Model.Columns.PrimaryKeyType>(Model.Columns.primaryColumn.name)
        let query = DefaultDeleteQuery.table.filter(primaryKeys.contains(primaryKeyExpression))
        try connection.run(query.delete())
    }

    /// this is exposed like this so you can use it when building your own queries
    public static func _deleteAll(connection: Connection) throws {
        let query = DefaultDeleteQuery.table
        try connection.run(query.delete())
    }

    public static func `where`(primaryKey: Model.Columns.PrimaryKeyType) -> DefaultDeleteQuery {
        return DefaultDeleteQuery { connection in
            try DefaultDeleteQuery._delete(wherePrimaryKey: primaryKey, connection: connection)
        }
    }

    public static func `where`(primaryKeys: [Model.Columns.PrimaryKeyType]) -> DefaultDeleteQuery {
        return DefaultDeleteQuery { connection in
            try DefaultDeleteQuery._delete(wherePrimaryKeys: primaryKeys, connection: connection)
        }
    }

    public static func model(_ model: Model) -> DefaultDeleteQuery {
        return DefaultDeleteQuery { connection in
            let primaryKey = try Model.Columns.primaryColumn.value(from: model)
            try DefaultDeleteQuery._delete(wherePrimaryKey: primaryKey, connection: connection)
        }
    }

    public static func models(_ models: [Model]) -> DefaultDeleteQuery {
        return DefaultDeleteQuery { connection in
            let primaryKeys = try models.map { model in try Model.Columns.primaryColumn.value(from: model) }
            try DefaultDeleteQuery._delete(wherePrimaryKeys: primaryKeys, connection: connection)
        }
    }

    public static var all: DefaultDeleteQuery {
        return DefaultDeleteQuery { connection in
            try DefaultDeleteQuery._deleteAll(connection: connection)
        }
    }

    private let block: (Connection) throws -> Void

    init(_ block: @escaping (Connection) throws -> Void) {
        self.block = block
    }

    public func run(using connection: Connection) throws {
        try self.block(connection)
    }
}
