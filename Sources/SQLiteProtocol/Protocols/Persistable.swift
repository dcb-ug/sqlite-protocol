//
//  Persistable.swift
//
//  Created by Manuel Reich on 27.11.18.
//

import SQLite

public protocol Persistable {
    associatedtype Columns: ColumnSchema where Columns.Model == Self
    associatedtype ReadQuery: ReadQueryProtocol = DefaultReadQuery<Self> where ReadQuery.Model == Self
    associatedtype WriteQuery: WriteQueryProtocol = DefaultWriteQuery<Self> where WriteQuery.Model == Self
    associatedtype DeleteQuery: DeleteQueryProtocol = DefaultDeleteQuery<Self> where DeleteQuery.Model == Self

    init(databaseColumns columns: Columns) throws
}
