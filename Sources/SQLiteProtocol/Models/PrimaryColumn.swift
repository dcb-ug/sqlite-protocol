//
//  PrimaryColumn.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 22.03.19.
//
import SQLite

public struct PrimaryColumn<Model, Columns: ColumnSchema, KeyType: Value> {
    private let mapper: (Model) throws -> KeyType

    public let name: String
    public let builder: Builder<Model, Columns>

    public init(_ name: String, _ keyPath: WritableKeyPath<Columns, KeyType>, _ mapper: @escaping (Model) throws -> KeyType) {
        self.mapper = mapper
        self.name = name
        self.builder = Builder(name, keyPath, mapper)
    }

    public func value(from model: Model) throws -> KeyType {
        return try mapper(model)
    }
}
