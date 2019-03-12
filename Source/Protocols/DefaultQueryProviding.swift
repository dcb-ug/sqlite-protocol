//
//  DefaultQueryProviding.swift
//  enter-ios
//
//  Created by Manuel Reich on 25.12.18.
//

//import Foundation

public protocol DefaultQueryProviding {
    static var delete: Self { get }
    static var createOrUpdate: Self { get }
}
