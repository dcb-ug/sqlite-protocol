//
//  WriteQueryProtocol.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 22.03.19.
//
import SQLite

public protocol WriteQueryProtocol {
    associatedtype Model
    static func createTableIfNotExists(for model: Model, using connection: Connection) throws
    func run(persisting model: Model, using connection: Connection) throws
}

extension WriteQueryProtocol {
    public static var table: Table {
        let name = "\(Model.self)"
        return Table(name)
    }
}

extension WriteQueryProtocol where Model: Persistable {
    public static func createTableIfNotExists(for model: Model, using connection: Connection) throws {
        let block = Model.Columns.buildTable
        let createTable = Self.table.create(ifNotExists: true, block: block)
        try connection.run(createTable)
    }
}
