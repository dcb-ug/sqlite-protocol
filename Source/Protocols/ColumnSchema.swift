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

    static var primaryColumn: PrimaryColumn<Model, Self, PrimaryKeyType> { get }
    static var columns: [Builder<Model, Self>] { get }

    init()

    static func buildTable(tableBuilder: TableBuilder)
    static func from(row: Row) -> Self
}

extension ColumnSchema {
    public static func buildTable(tableBuilder: TableBuilder) {
        self.primaryColumn.builder.createColumn(tableBuilder)
        for column in self.columns {
            column.createColumn(tableBuilder)
        }
    }

    public static func from(row: Row) -> Self {
        var columns = Self.init()
        self.primaryColumn.builder.addValue(row, &columns)
        for column in self.columns {
            column.addValue(row, &columns)
        }
        return columns
    }

    public static func primaryKeySelector(value: PrimaryKeyType) -> Expression<Bool> {
        let expression = Expression<PrimaryKeyType>(Self.primaryColumn.name)
        return expression == value
    }
}
