//
//  Database.swift
//  enter-ios
//
//  Created by Manuel Reich on 17.12.18.
//

//import Foundation
import SQLite

public final class Database {
    private static var sharedConnection: Connection?
    private let database: Connection

    public init() {
        if let sharedConnection = Database.sharedConnection {
            database = sharedConnection
        } else {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            database = try! Connection("\(path)/db.sqlite3") // swiftlint:disable:this force_try
        }
    }

    public func getFirst<Model: Persistable>(_ ofType: Model.Type) throws -> Model? {
        do {
            guard let row = try database.pluck(Model.table) else { return nil }
            return try Model(databaseRow: row)
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            return nil
        }
    }

    public func getAll<Model: Persistable>(_ ofType: Model.Type) throws -> [Model] {
        do {
            let result = try database.prepare(Model.table)
            return try Array(result).map { try Model(databaseRow: $0) }
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            return []
        }
    }

    public func write<Model: Persistable>(_ query: Model.WriteQuery, _ model: Model) throws {
        do {
            try query.run(persisting: model, inside: database)
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            let createTable = Model.table.create(ifNotExists: true, block: Model.schema)
            try database.run(createTable)
            try query.run(persisting: model, inside: database)
        }
    }
}
