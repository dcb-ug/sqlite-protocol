//
//  Database.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 17.12.18.
//

import Foundation
import SQLite

/// Stores a shared Connection to a Database and provides functions to run read or write queries
public final class Database {
    private static var sharedConnection: Connection?
    private let connection: Connection

    public init() {
        if let sharedConnection = Database.sharedConnection {
            connection = sharedConnection
        } else {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            connection = try! Connection("\(path)/db.sqlite3") // swiftlint:disable:this force_try
        }
    }

    public func write<Model: QueryProviding>(_ query: Model.WriteQuery, _ model: Model) throws {
        try query.run(persisting: model, using: connection)
    }

    public func write<Model: QueryProviding>(_ query: Model.WriteQuery, _ models: [Model]) throws {
        try connection.transaction {
            for model in models { try write(query, model) }
        }
    }

    public func write<Model: Persistable>(_ query: Model.WriteQuery, _ model: Model) throws {
        try query.runAndCreateTableIfNotExists(persisting: model, using: connection)
    }

    public func write<Model: Persistable>(_ query: Model.WriteQuery, _ models: [Model]) throws {
        try connection.transaction {
            for model in models { try write(query, model) }
        }
    }

    public func read<Model: QueryProviding>(_ query: Model.ReadQuery, ofType: Model.Type) throws -> [Model] {
        return try query.run(using: connection)
    }

    public func read<Model: Persistable>(_ query: Model.ReadQuery, ofType: Model.Type) throws -> [Model] {
        return try query.run(using: connection)
    }

    public func delete<Model: QueryProviding>(_ query: Model.DeleteQuery, ofType type: Model.Type) throws {
        try query.run(using: connection)
    }

    public func delete<Model: Persistable>(_ query: Model.DeleteQuery, ofType type: Model.Type) throws {
        try query.run(using: connection)
    }
}
