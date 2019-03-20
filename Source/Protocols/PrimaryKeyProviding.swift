////
////  PrimaryKeyProviding.swift
////  DifferenceKit
////
////  Created by Manuel Reich on 12.03.19.
////
//
//import SQLite
//
//public protocol PrimaryKeyProviding where PrimaryKeyType.Datatype: Equatable {
//    associatedtype PrimaryKeyType: Value
//
//    static var primaryKey: Expression<PrimaryKeyType> { get }
//    var primaryKeyValue: PrimaryKeyType { get }
//}
