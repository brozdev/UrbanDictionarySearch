//
//  DictionaryPublisher.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/9/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import Combine
import Foundation

enum SortOrder {
    case mostToLeast
    case leastToMost
}

protocol DictionaryPublisher: Publisher {
    func fetchDefinitions(for searchTerm: String, sortOrder: SortOrder)
}
