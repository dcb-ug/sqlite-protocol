//
//  DefaultQueryProviding.swift
//  enter-ios
//
//  Created by Manuel Reich on 25.12.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

import Foundation

public protocol DefaultQueryProviding {
    static var delete: Self { get }
    static var createOrUpdate: Self { get }
}
