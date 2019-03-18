//
//  AnyReadQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

//import Foundation
import SQLite

open class AnyReadQuery<Model>: ReadQueryProtocol {
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
