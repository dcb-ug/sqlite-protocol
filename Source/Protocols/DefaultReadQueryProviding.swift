//
//  DefaultWriteQueryProviding.swift
//
//  Created by Manuel Reich on 25.12.18.
//

public protocol DefaultReadQueryProviding {
    associatedtype PrimaryKeyType

    static var getFirst: Self { get }
    static func getByPrimaryKey(_ key: PrimaryKeyType) -> Self
}
