//
//  DefaultWriteQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultWriteQuery<Model: Persistable>: WriteQueryProtocol {

    public static func _createOrUpdateFunction(model: Model, connection: Connection) throws {
        let setters = try Model.Columns.columns.map { try $0.buildSetter(model) }
        try connection.run(DefaultWriteQuery.table.insert(or: .replace, setters))
    }

    public static var createOrUpdate: DefaultWriteQuery {
        return DefaultWriteQuery { model, connection in
            try DefaultWriteQuery._createOrUpdateFunction(model: model, connection: connection)
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
