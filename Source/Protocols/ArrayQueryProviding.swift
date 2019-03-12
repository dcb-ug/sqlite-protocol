//
//  ArrayQueryProviding.swift
//  enter-ios
//
//  Created by Manuel Reich on 23.12.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

import Foundation
import SQLite

public protocol ArrayQueryProviding {
    associatedtype ArrayQuery: DatabseQuery = DefaultQuery<[Self]> where ArrayQuery.Model == [Self]
}
