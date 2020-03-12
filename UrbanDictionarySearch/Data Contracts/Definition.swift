//
//  Definition.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/8/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import Foundation

protocol Definition {
    var searchTerm: String { get }
    var text: String { get }
    var upVoteCount: Int { get }
    var downVoteCount: Int { get }
}

extension Array where Element: Definition {
    var leastToMost: [Definition] {
        return self.sorted { (lhs, rhs) -> Bool in
            lhs.downVoteCount < rhs.downVoteCount
        }
    }
}
