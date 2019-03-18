//
//  Persistable.swift
//
//  Created by Manuel Reich on 27.11.18.
//

import SQLite

public protocol Persistable {
    associatedtype Columns
    associatedtype WriteQuery: WriteQueryProtocol = DefaultWriteQuery<Self> where WriteQuery.Model == Self
    associatedtype ReadQuery: ReadQueryProtocol = DefaultReadQuery<Self> where ReadQuery.Model == Self

    static var table: Table { get }
    var singleRowSelector: Expression<Bool> { get }

    init(databaseRow: Row) throws

    static func schema(tableBuilder: TableBuilder)
}

extension Persistable where Self: PrimaryKeyProviding {
    public var singleRowSelector: Expression<Bool> {
        return Self.primaryKey == self.primaryKeyValue
    }
}
