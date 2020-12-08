//
//  _39UnitTestingTests.swift
//  139UnitTestingTests
//
//  Created by Mirko Braic on 04/12/2020.
//

import XCTest
@testable import _39UnitTesting

class _39UnitTestingTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }

    func testAllWordsLoaded() {
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords count was not 18440")
    }

    func testWordCountsAreCorrect() {
        let playData = PlayData()
        XCTAssertEqual(playData.wordCounts.count(for: "home"), 174, "Home does not appear 174 times")
        XCTAssertEqual(playData.wordCounts.count(for: "fun"), 4, "Fun does not appear 4 times")
        XCTAssertEqual(playData.wordCounts.count(for: "mortal"), 41, "Mortal does not appear 41 times")
    }
    
    func testWordsLoadQuickly() {
        measure {
            _ = PlayData()
        }
    }
    
    func testUserFilterPerformace() {
        let playData = PlayData()
        
        measure {
            playData.applyUserFilter("100")
        }
    }
    
    func testUserFilterWorks() {
        let playData = PlayData()

        playData.applyUserFilter("100")
        XCTAssertEqual(playData.filteredWords.count, 495)

        playData.applyUserFilter("1000")
        XCTAssertEqual(playData.filteredWords.count, 55)

        playData.applyUserFilter("10000")
        XCTAssertEqual(playData.filteredWords.count, 1)

        playData.applyUserFilter("test")
        XCTAssertEqual(playData.filteredWords.count, 56)

        playData.applyUserFilter("swift")
        XCTAssertEqual(playData.filteredWords.count, 7)

        playData.applyUserFilter("objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0)
    }
}
