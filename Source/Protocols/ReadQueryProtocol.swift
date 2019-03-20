//
//  ReadQueryProtocol.swift
//
//  Created by Manuel Reich on 12.03.19.
//

import SQLite

public protocol ReadQueryProtocol {
    associatedtype Model

    static var table: Table { get }

    func run(inside database: Connection) throws -> Model?
}

extension ReadQueryProtocol {
    public static var table: Table {
        let name = "\(Model.self)"
        return Table(name)
    }
}
