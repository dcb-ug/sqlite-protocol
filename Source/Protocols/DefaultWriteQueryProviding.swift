//
//  DefaultWriteQueryProviding.swift
//
//  Created by Manuel Reich on 25.12.18.
//

public protocol DefaultWriteQueryProviding {
    static var delete: Self { get }
    static var createOrUpdate: Self { get }
}
