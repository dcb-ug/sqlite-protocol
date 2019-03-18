//
//  ConstructableFromArray.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 18.03.19.
//

public protocol ContsructableFromArray {
    associatedtype Element
    init (_ array: Array<Element>)
}

extension Array: ContsructableFromArray {}
extension Set: ContsructableFromArray {}
extension AnySequence: ContsructableFromArray {}
