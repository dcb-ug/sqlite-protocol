//
//  DefaultWriteQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultWriteQuery<Model: Persistable>: WriteQueryProtocol {
    public static var delete: DefaultWriteQuery {
        return DefaultWriteQuery { model, connection in
//            let columns = try Model.Columns(model: model)
//            let row = DefaultWriteQuery.table.filter(columns.primaryKeySelector)
//            try connection.run(row.delete())
        }
    }

    public static var createOrUpdate: DefaultWriteQuery {
        return DefaultWriteQuery { model, connection in
            let setters = try Model.Columns.columns.map { try $0.buildSetter(model) }
            try connection.run(DefaultWriteQuery.table.insert(or: .replace, setters))
        }
    }

    private let block: (Model, Connection) throws -> Void

    init(_ block: @escaping (Model, Connection) throws -> Void) {
        self.block = block
    }

    public func run(persisting model: Model, using connection: Connection) throws {
        try self.block(model, connection)
    }
}
