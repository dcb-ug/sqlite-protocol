//
//  Persistable.swift
//  enter-ios
//
//  Created by Manuel Reich on 27.11.18.
//

import SQLite

public protocol Persistable {
    associatedtype Columns
    associatedtype Query: DatabaseQuery = DefaultQuery<Self> where Query.Model == Self

    static var table: Table { get }
    var databaseRowSelector: Expression<Bool> { get }

    init(databaseRow: Row) throws

    static func schema(tableBuilder: TableBuilder)
}
