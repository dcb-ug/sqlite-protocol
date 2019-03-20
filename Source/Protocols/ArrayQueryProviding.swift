//
//  ArrayQueryProviding.swift
//
//  Created by Manuel Reich on 23.12.18.
//

import SQLite

public protocol ArrayQueryProviding: Persistable {
    associatedtype ArrayWriteQuery: WriteQueryProtocol = DefaultWriteQuery<[Self]> where ArrayWriteQuery.Model == [Self]
}
