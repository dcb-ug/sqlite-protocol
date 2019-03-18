//
//  ReadQueryProtocol.swift
//
//  Created by Manuel Reich on 12.03.19.
//

import SQLite

public protocol ReadQueryProtocol {
    associatedtype Model

    func run(inside database: Connection) throws -> Model?
}
