//
//  ReadQueryProtocol.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 22.03.19.
//
import SQLite

public protocol ReadQueryProtocol {
    associatedtype Model
    func run(using connection: Connection) throws -> [Model]
}
