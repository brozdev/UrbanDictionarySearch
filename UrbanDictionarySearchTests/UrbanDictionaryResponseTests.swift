//
//  UrbanDictionaryResponseTests.swift
//  UrbanDictionarySearchTests
//
//  Created by Brian Rozboril on 3/10/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import UIKit
@testable import UrbanDictionarySearch
import XCTest

class UrbanDictionaryResponseTests: XCTestCase {

    var responseExample = """
        {
            "definition": "The only [proper] [response] to something that makes absolutely no sense.",
            "permalink": "http:wat.urbanp.com/3322419",
            "thumbs_up": 3663,
            "author": "watwat",
            "defid": 3322419,
            "thumbs_down": 423,
            "word" : "wat"
        }
    """.data(using: .utf8)!
    
    func testResponseDecoding() {
        let expectedDefinition = "The only [proper] [response] to something that makes absolutely no sense."
        let expectedUpVoteCount = 3663
        let expectedDownVoteCount = 423
        
        guard let testDefinition = try? JSONDecoder().decode(UrbanDictionaryResponse.TermDefinition.self, from: responseExample)
        else {
            XCTFail("Could not get data to test.")
            return
        }
        
        XCTAssertEqual(testDefinition.definition, expectedDefinition)
        XCTAssertEqual(testDefinition.upVoteCount, expectedUpVoteCount)
        XCTAssertEqual(testDefinition.downVoteCount, expectedDownVoteCount)
    }
    
    func testDecodingTime() {
        guard
            let sampleResponseURL = Bundle(for: type(of: self)).url(forResource: "jsonresponse", withExtension: "json"),
            let sampleData = try? Data(contentsOf: sampleResponseURL)
        else {
            XCTFail("Could not get sample data.")
            return
        }
        
        measure {
            let response = try? JSONDecoder().decode(UrbanDictionaryResponse.self, from: sampleData)
        }
    }
}
