//
//  Array+Persistable.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

//import Foundation
import SQLite

/// When an Element of an Array is Persistable the array is Persistable too
extension Array: Persistable where Element: Persistable & ArrayQueryProviding {
    public typealias Schema = Element.Schema

    // TODO: Im not shure this creates the correct expression to select multiple rows
    // especially I have no idea what Expression<Bool>("") means when it is combined with an other expression
    public var singleRowSelector: Expression<Bool> {
        return self.reduce(Expression<Bool>("")) { prev, next in
            return prev || next.singleRowSelector
        }
    }

//    public typealias WriteQuery = Element.ArrayWriteQuery

    public static var table: Table {
        return Element.Schema.table
    }

    public init(databaseRow: Schema) throws {
        let model = try Element(databaseRow: databaseRow)
        self = [model]
    }
//
//    public static func schema(tableBuilder: TableBuilder) {
//        Element.schema(tableBuilder: tableBuilder)
//    }
}
