//
//  ColumnSettersProviding.swift
//  enter-ios
//
//  Created by Manuel Reich on 25.12.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

import Foundation
import SQLite

public protocol ColumnSettersProviding {
    var columnSetters: [Setter] { get }
}
