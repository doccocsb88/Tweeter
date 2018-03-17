//
//  MessageTests.swift
//  TweeterTests
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import XCTest
@testable import Tweeter

class MessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testSplitMessage(){
        let message = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expectedSplitedMessages1 = ["1/2 I can't believe Tweeter now supports chunking", "2/2 my messages, so I don't have to do it myself."]
        let expectedSplitedMessages2 = ["1/2 I can't believe Tweeter now supports chunking", "2/2 my messages, so I don't have to do it myself."]
        
        //        do{
        //            let splitedMessage = try splitMessage(message: message)
        //
        //        }catch{
        //
        //        }
        XCTAssertEqual(expectedSplitedMessages1, expectedSplitedMessages2)
    }
    
}
