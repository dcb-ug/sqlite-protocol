//
//  Array+Persistable.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

//import Foundation
import SQLite

extension Array: Persistable where Element: Persistable & ArrayQueryProviding {
    // TODO: Im not shure this creates the correct expression to select multiple rows
    // especially I have no idea what Expression<Bool>("") means when it is combined with an other expression
    public var databaseRowSelector: Expression<Bool> {
        return self.reduce(Expression<Bool>("")) { prev, next in
            return prev || next.databaseRowSelector
        }
    }

    public typealias Columns = Element.Columns
    public typealias Query = Element.ArrayQuery

    public static var table: Table {
        return Element.table
    }

    public init(databaseRow: Row) throws {
        self = []
    }

    public static func schema(tableBuilder: TableBuilder) {
        Element.schema(tableBuilder: tableBuilder)
    }
}
