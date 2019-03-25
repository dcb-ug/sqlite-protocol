//
//  Column.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 22.03.19.
//

public struct Column<Schema, ValueType> {
    public let name: String
    public let path: KeyPath<Schema, ValueType>

    public init(name: String, keyPath: KeyPath<Schema, ValueType>) {
        self.name = name
        self.path = keyPath
    }
}
