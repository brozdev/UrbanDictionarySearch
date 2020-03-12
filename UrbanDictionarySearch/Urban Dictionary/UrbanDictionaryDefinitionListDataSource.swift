//
//  UrbanDictionaryDefinitionListDataSource.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/8/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import Foundation

struct UrbanDictionaryDefinitionListDataSource: DefinitionListDataSource {
    var isFetching: Bool
    var searchTerm: String
    var definitions: [Definition]?
    var statusMessage: String?
    
    init(isFetching: Bool, searchTerm: String, definitions: [Definition]?) {
        self.isFetching = isFetching
        self.searchTerm = searchTerm
        self.definitions = definitions
    }
    
    init(searchTerm: String, statusMessage: String) {
        self.isFetching = false
        self.searchTerm = searchTerm
        self.statusMessage = statusMessage
    }
}
