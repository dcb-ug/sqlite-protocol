//
//  ArrayQueryProviding.swift
//
//  Created by Manuel Reich on 23.12.18.
//

import SQLite

public protocol ArrayQueryProviding {
    associatedtype ArrayQuery: WriteQueryProtocol = DefaultQuery<[Self]> where ArrayQuery.Model == [Self]
}
