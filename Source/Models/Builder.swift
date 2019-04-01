//
//  Builder.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 01.04.19.
//

import SQLite

public struct Builder<Model, Columns: ColumnSchema> {
    public let buildSetter: (Model) throws -> Setter
    public let createColumn: (TableBuilder) -> Void
    public let addValue: (Row, inout Columns) -> Void

    public init<Property: Value>(_ name: String, _ keyPath: WritableKeyPath<Columns, Property>, _ mapper: @escaping (Model) throws -> Property) {
        let expression = Expression<Property>(name)

        buildSetter = {(model: Model) -> Setter in
            let value = try mapper(model)
            return expression <- value
        }

        createColumn = { (tableBuilder: TableBuilder) in
            let isPrimary = name == Columns.primaryKey.name
            tableBuilder.column(expression, primaryKey: isPrimary)
        }

        addValue = { (row: Row, columns: inout Columns) in
            let value = row[expression]
            columns[keyPath: keyPath] = value
        }
    }

    public init<Property: Value>(_ name: String, _ keyPath: WritableKeyPath<Columns, Property?>, _ mapper: @escaping (Model) throws -> Property?) {
        let expression = Expression<Property?>(name)

        buildSetter = {(model: Model) -> Setter in
            let value = try mapper(model)
            return expression <- value
        }

        createColumn = { (tableBuilder: TableBuilder) in
            // optional values can't be a primaryKey
            tableBuilder.column(expression)
        }

        addValue = { (row: Row, columns: inout Columns) in
            let value = row[expression]
            columns[keyPath: keyPath] = value
        }
    }
}
