//
//  WriteQueryProtocol.swift
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public protocol WriteQueryProtocol {
    associatedtype Model

    static var table: Table { get }

    func run(persisting model: Model, inside database: Connection) throws
}

extension WriteQueryProtocol {
    public static var table: Table {
        let name = "\(Model.self)"
        return Table(name)
    }
}
