//
//  WriteQueryProtocol.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 22.03.19.
//
import SQLite

public protocol WriteQueryProtocol {
    associatedtype Model
    func createTableIfNotExists(using connection: Connection) throws
    func run(persisting model: Model, using connection: Connection) throws
}
