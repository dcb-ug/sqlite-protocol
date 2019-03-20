//
//  Persistable.swift
//
//  Created by Manuel Reich on 27.11.18.
//

import SQLite

public protocol Persistable {
    associatedtype Schema: TableSchema where Schema.Model == Self
    associatedtype WriteQuery: WriteQueryProtocol = DefaultWriteQuery<Self> where WriteQuery.Model == Self
    associatedtype ReadQuery: ReadQueryProtocol = DefaultReadQuery<Self> where ReadQuery.Model == Self

    init(databaseRow: Schema) throws
}
