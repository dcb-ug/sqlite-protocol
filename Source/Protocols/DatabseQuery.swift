//
//  DatabseQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

import SQLite

public protocol DatabseQuery {
    associatedtype Model

    func run(persisting model: Model, inside database: Connection) throws
}
