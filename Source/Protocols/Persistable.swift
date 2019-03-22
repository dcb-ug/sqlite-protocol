//
//  Persistable.swift
//
//  Created by Manuel Reich on 27.11.18.
//

import SQLite

public protocol Persistable {
    associatedtype Columns: Schema where Columns.Model == Self
    associatedtype ReadQuery: ReadQueryProtocol = DefaultReadQuery<Self> where ReadQuery.Model == Self
    associatedtype WriteQuery: WriteQueryProtocol = DefaultWriteQuery<Self> where WriteQuery.Model == Self

    init(databaseColumns: Columns) throws
}
