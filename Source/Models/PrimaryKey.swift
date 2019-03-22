//
//  PrimaryKey.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 22.03.19.
//

public struct PrimaryKey<Schema, KeyType> {
    public let column: String
    public let path: KeyPath<Schema, KeyType>

    public init(column: String, keyPath: KeyPath<Schema, KeyType>) {
        self.column = column
        self.path = keyPath
    }
}
