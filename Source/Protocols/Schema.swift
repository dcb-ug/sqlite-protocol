//
//  Schema.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 20.03.19.
//

import SQLite

public struct PrimaryKey<Schema, KeyType> {
    public let name: String
    public let path: KeyPath<Schema, KeyType>

    public init(name: String, keyPath: KeyPath<Schema, KeyType>) {
        self.name = name
        self.path = keyPath
    }
}

public protocol Schema {
    associatedtype Model
    associatedtype PrimaryKeyType: Value where PrimaryKeyType.Datatype: Equatable

    typealias Column = (setterBuilder: (Model) -> Setter,
                        columnBuilder: (TableBuilder) -> Void,
                        addColumnValue: (Row, Self) -> Self)

    static var columns: [Column] { get }
    static var primaryKey: PrimaryKey<Self, PrimaryKeyType> { get }

    init()
    init(model: Model)
}

extension Schema {

    public static func columnBuilder<Property: Value>(path: WritableKeyPath<Self, Property?>, name: String) -> Column {
        let expression = Expression<Property?>(name)

        let setterBuilder = {(model: Model) -> Setter in
            let schema = Self(model: model)
            let value = schema[keyPath: path]
            return expression <- value
        }

        let columnBuilder = { (tableBuilder: TableBuilder) in tableBuilder.column(expression) }

        let addColumnValue = { (row: Row, columns: Self) -> Self in
            var columns = columns
            let value = row[expression]
            columns[keyPath: path] = value
            return columns
        }

        return (setterBuilder, columnBuilder, addColumnValue)
    }

    public static func columnBuilder<Property: Value>(path: WritableKeyPath<Self, Property>, name: String) -> Column {
        return columnBuilder(path: path, name: name)
    }

    public static func buildTable(tableBuilder: TableBuilder) {
        for column in self.columns {
            column.columnBuilder(tableBuilder)
        }
    }

    public static func from(row: Row) -> Self {
        var columns = Self.init()
        for column in self.columns {
            columns = column.addColumnValue(row, columns)
        }
        return columns
    }

    public static func primaryKeySelector(value: PrimaryKeyType) -> Expression<Bool> {
        let expression = Expression<PrimaryKeyType>(Self.primaryKey.name)
        return expression == value
    }

    public var primaryKeySelector: Expression<Bool> {
        let expression = Expression<PrimaryKeyType>(Self.primaryKey.name)
        let value = self[keyPath: Self.primaryKey.path]
        return expression == value
    }
}
