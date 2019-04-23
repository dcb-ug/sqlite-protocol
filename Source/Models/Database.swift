//
//  Database.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 17.12.18.
//

//import Foundation
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

    public func write<Model: Persistable>(_ query: Model.WriteQuery, _ model: Model) throws {
        try query.runAndCreateTableIfNotExists(persisting: model, using: connection)
    }

    public func write<Model: Persistable>(_ query: Model.WriteQuery, _ models: [Model]) throws {
        for model in models {
            // TODO: this sucks if it fails half way through so put it in a transction
            // also at least for default queries it should pe possible to optimize this for less database calls
            try write(query, model)
        }
    }

    public func read<Model: QueryProviding>(_ query: Model.ReadQuery, ofType: Model.Type) throws -> [Model] {
        do {
            return try query.run(using: connection)
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            return []
        }
    }

    public func read<Model: Persistable>(_ query: Model.ReadQuery, ofType: Model.Type) throws -> [Model] {
        do {
            return try query.run(using: connection)
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            return []
        }
    }
}
