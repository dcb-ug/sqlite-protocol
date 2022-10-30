//
//  DefaultWriteQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite
import SQLite3

public final class DefaultDeleteQuery<Model: Persistable>: DeleteQueryProtocol {

    /// this is exposed like this so you can use it when building your own queries
    public static func _delete(wherePrimaryKey primaryKey: Model.Columns.PrimaryKeyType, connection: Connection) throws {
        let primaryKeySelector = Model.Columns.primaryKeySelector(value: primaryKey)
        let query = DefaultDeleteQuery.table.filter(primaryKeySelector)
        try delete(selection: query, using: connection)
    }

    /// this is exposed like this so you can use it when building your own queries
    public static func _delete(wherePrimaryKeys primaryKeys: [Model.Columns.PrimaryKeyType], connection: Connection) throws {
        guard primaryKeys.count > 0 else {
            // this is so that deleting 0 elemnts will not throw an error
            // even when there was no table created for that model jet
            return
        }
        let primaryKeyExpression = Expression<Model.Columns.PrimaryKeyType>(Model.Columns.primaryColumn.name)
        let query = DefaultDeleteQuery.table.filter(primaryKeys.contains(primaryKeyExpression))
        try delete(selection: query, using: connection)
    }

    /// this is exposed like this so you can use it when building your own queries
    public static func _deleteAll(connection: Connection) throws {
        try delete(selection: DefaultDeleteQuery.table, using: connection)
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

    private static func delete(selection: Table, using connection: Connection) throws {
        do {
            try connection.run(selection.delete())
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            // we swallow "no such table" errors because this means the entry is not there
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
