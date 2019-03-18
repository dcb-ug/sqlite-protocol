//
//  DefaultWriteQueryProviding.swift
//
//  Created by Manuel Reich on 25.12.18.
//

public protocol DefaultReadQueryProviding {
    associatedtype PrimaryKeyType

    static var first: Self { get }
    static func withPrimaryKey(_ key: PrimaryKeyType) -> Self
}
