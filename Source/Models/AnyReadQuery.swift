//
//  AnyReadQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

/// Subclass this if you want to write your own custom read queries
open class AnyReadQuery<Model>: ReadQueryProtocol {
    public static var table: Table {
        let name = "\(Model.self)"
        return Table(name)
    }

    private let block: (Connection) throws -> Model?

    public init(block: @escaping (Connection) throws -> Model?) {
        self.block = block
    }

    public func run(inside database: Connection) throws -> Model? {
        do {
            return try self.block(database)
        } catch let Result.error(message, code, _) where code == SQLITE_ERROR && message.hasPrefix("no such table") {
            return nil
        }
    }
}
