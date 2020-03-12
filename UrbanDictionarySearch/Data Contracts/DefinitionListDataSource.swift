//
//  DefinitionListDataSource.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/8/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import Foundation

protocol DefinitionListDataSource {
    var isFetching: Bool { get }
    var searchTerm: String { get }
    var definitions: [Definition]? { get }
    var statusMessage: String? { get} 
}
