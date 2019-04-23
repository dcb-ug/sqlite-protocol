//
//  WriteQueryProtocol.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 22.03.19.
//
import SQLite

public protocol WriteQueryProtocol {
    associatedtype Model
    func run(persisting model: Model, using connection: Connection) throws
}

extension WriteQueryProtocol {
    public static var table: Table {
        let name = "\(Model.self)"
        return Table(name)
    }
}

extension WriteQueryProtocol where Model: Persistable {
    public func runAndCreateTableIfNotExists(persisting model: Model, using connection: Connection) throws {
        do {
            try self.run(persisting: model, using: connection)
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            let block = Model.Columns.buildTable
            let createTable = Self.table.create(ifNotExists: true, block: block)
            try connection.run(createTable)
            try self.run(persisting: model, using: connection)
        }
    }
}
