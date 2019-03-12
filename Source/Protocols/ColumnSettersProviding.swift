//
//  ColumnSettersProviding.swift
//  enter-ios
//
//  Created by Manuel Reich on 25.12.18.
//

//import Foundation
import SQLite

public protocol ColumnSettersProviding {
    var columnSetters: [Setter] { get }
}
