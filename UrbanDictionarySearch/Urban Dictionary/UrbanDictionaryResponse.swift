//
//  UrbanDictionaryResponse.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/8/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import Foundation

struct UrbanDictionaryResponse: Decodable {
    struct TermDefinition: Decodable {
        enum CodingKeys: String, CodingKey {
            case definition
            case thumbsDown = "thumbs_down"
            case thumbsUp = "thumbs_up"
            case searchTerm = "word"
        }
        
        let definition: String
        let thumbsUp: Int
        let thumbsDown: Int
        let searchTerm: String
    }
    
    let list: [TermDefinition]
}

extension UrbanDictionaryResponse.TermDefinition: Definition {
    var text: String {
        return definition
    }
    
    var upVoteCount: Int {
        return thumbsUp
    }
    
    var downVoteCount: Int {
        return thumbsDown
    }
}
