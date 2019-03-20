//
//  DefaultWriteQueryProviding.swift
//
//  Created by Manuel Reich on 25.12.18.
//
import SQLite

public protocol DefaultWriteQueryProviding {
    static var table: Table { get }

    static var delete: Self { get }
    static var createOrUpdate: Self { get }
}
