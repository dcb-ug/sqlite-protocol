//
//  Schema.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 20.03.19.
//

import SQLite

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
    public static func build<Property: Value>(column name: String, keyPath: WritableKeyPath<Self, Property>) -> Column {
        let expression = Expression<Property>(name)

        let setterBuilder = {(model: Model) -> Setter in
            let schema = Self(model: model)
            let value = schema[keyPath: keyPath]
            return expression <- value
        }

        let columnBuilder = { (tableBuilder: TableBuilder) in tableBuilder.column(expression) }

        let addColumnValue = { (row: Row, columns: Self) -> Self in
            var columns = columns
            let value = row[expression]
            columns[keyPath: keyPath] = value
            return columns
        }

        return (setterBuilder, columnBuilder, addColumnValue)
    }

    // TODO: this must be possible without writeing everything twice
    public static func build<Property: Value>(column name: String, keyPath: WritableKeyPath<Self, Property?>) -> Column {
        let expression = Expression<Property?>(name)

        let setterBuilder = {(model: Model) -> Setter in
            let schema = Self(model: model)
            let value = schema[keyPath: keyPath]
            return expression <- value
        }

        let columnBuilder = { (tableBuilder: TableBuilder) in tableBuilder.column(expression) }

        let addColumnValue = { (row: Row, columns: Self) -> Self in
            var columns = columns
            let value = row[expression]
            columns[keyPath: keyPath] = value
            return columns
        }

        return (setterBuilder, columnBuilder, addColumnValue)
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
        let expression = Expression<PrimaryKeyType>(Self.primaryKey.column)
        return expression == value
    }

    public var primaryKeySelector: Expression<Bool> {
        let expression = Expression<PrimaryKeyType>(Self.primaryKey.column)
        let value = self[keyPath: Self.primaryKey.path]
        return expression == value
    }
}