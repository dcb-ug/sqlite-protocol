//
//  AnyWriteQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

//import Foundation
import SQLite

/// Subclass this if you want to write your own custom write queries
open class AnyWriteQuery<Model: Persistable>: WriteQueryProtocol {
    public static var table: Table {
        let name = "\(Model.self)"
        return Table(name)
    }

    public func createTableIfNotExists(inside database: Connection) throws {
        let block = Model.Columns.buildTable
        let createTable = AnyWriteQuery.table.create(ifNotExists: true, block: block)
        try database.run(createTable)
    }
    
    private let block: (Model, Connection) throws -> Void

    public init(block: @escaping (Model, Connection) throws -> Void) {
        self.block = block
    }

    public func run(persisting model: Model, inside database: Connection) throws {
        try self.block(model, database)
    }
}
