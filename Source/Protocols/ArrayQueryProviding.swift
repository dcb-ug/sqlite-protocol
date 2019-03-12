//
//  ArrayQueryProviding.swift
//  enter-ios
//
//  Created by Manuel Reich on 23.12.18.
//

//import Foundation
import SQLite

public protocol ArrayQueryProviding {
    associatedtype ArrayQuery: DatabaseQuery = DefaultQuery<[Self]> where ArrayQuery.Model == [Self]
}
