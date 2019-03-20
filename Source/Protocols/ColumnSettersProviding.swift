//
//  ColumnSettersProviding.swift
//
//  Created by Manuel Reich on 25.12.18.
//

//import Foundation
import SQLite

public protocol ColumnSettersProviding {
    typealias ColumnSetter = (setterBuilder: (Self) -> Setter,
                              columnBuilder: (TableBuilder) -> Void)
    static var columnSetters: [ColumnSetter] { get }
}

public extension ColumnSettersProviding {
    public static func columnBuilder<Property, ColumnValue: Value>(path: KeyPath<Self, Property>,
                                                                   mapper: @escaping (Property) -> ColumnValue,
                                                                   name: String) -> ColumnSetter {
        let expression = Expression<ColumnValue>(name)

        let setterBuilder = {(model: Self) -> Setter in
            let property = model[keyPath: path]
            let value = mapper(property)
            return expression <- value
        }

        let columnBuilder = { (tableBuilder: TableBuilder) in tableBuilder.column(expression) }

        return (setterBuilder, columnBuilder)
    }

    public static func columnBuilder<Property: Value>(path: KeyPath<Self, Property>, name: String) -> ColumnSetter {
        let defaultMapper: (Property) -> Property =  { $0 }
        return Self.columnBuilder(path: path, mapper: defaultMapper, name: name)
    }
}

// how about this:

//protocol Representation {
//    associatedtype Model
//    associatedtype Primary
//    static var columns: CoulumnSetter { get }
//    static var primaryKey: Primary { get }
//
//    init(model: Model)
//
//    func toModel() -> Model
//}
//
//struct Hui: Representation {
//    let id: String
//
//    static let columns = [builder(path: \Hui.id, name: "id")]
//}
