//
//  Persistable.swift
//  enter-ios
//
//  Created by Manuel Reich on 27.11.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

import SQLite

public protocol Persistable {
    associatedtype Columns
    associatedtype Query: DatabseQuery = DefaultQuery<Self> where Query.Model == Self

    static var table: Table { get }
    var databaseRowSelector: Expression<Bool> { get }

    init(databaseRow: Row) throws

    static func schema(tableBuilder: TableBuilder)
}
