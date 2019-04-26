//
//  QueryProviding.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 23.04.19.
//

import SQLite

public protocol QueryProviding {
    associatedtype ReadQuery: ReadQueryProtocol where ReadQuery.Model == Self
    associatedtype WriteQuery: WriteQueryProtocol where WriteQuery.Model == Self
    associatedtype DeleteQuery: DeleteQueryProtocol where DeleteQuery.Model == Self
}
