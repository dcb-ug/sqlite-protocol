//
//  AnyQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

import Foundation
import SQLite

public class AnyQuery<Model>: DatabaseQuery {
    private let block: (Model, Connection) throws -> Void

    init(block: @escaping (Model, Connection) throws -> Void) {
        self.block = block
    }

    public func run(persisting model: Model, inside database: Connection) throws {
        try self.block(model, database)
    }
}
