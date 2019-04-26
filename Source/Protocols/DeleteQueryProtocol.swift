//
//  DeleteQueryProtocol.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 26.04.19.
//

import SQLite

public protocol DeleteQueryProtocol {
    associatedtype Model
    func run(using connection: Connection) throws
}

extension DeleteQueryProtocol {
    public static var table: Table {
        let name = "\(Model.self)"
        return Table(name)
    }
}
