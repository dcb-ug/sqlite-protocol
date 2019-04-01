//
//  ColumnSchema.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 20.03.19.
//

import SQLite

public protocol ColumnSchema {
    associatedtype Model
    associatedtype PrimaryKeyType: Value where PrimaryKeyType.Datatype: Equatable

    static var columns: [Builder<Model, Self>] { get }
    static var primaryKey: Column<Self, PrimaryKeyType> { get }

    init()
}

extension ColumnSchema {
    public static func buildTable(tableBuilder: TableBuilder) {
        for column in self.columns {
            column.createColumn(tableBuilder)
        }
    }

    public static func from(row: Row) -> Self {
        var columns = Self.init()
        for column in self.columns {
            column.addValue(row, &columns)
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
