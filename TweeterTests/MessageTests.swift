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
    let testMessage = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
    let testLongMessage = "Writing tests isn’t glamorous, but since tests can keep your sparkling app from turning into a bug-ridden piece of junk, it sure is necessary. If you’re reading this iOS Unit Testing and UI Testing tutorial, you already know you should write tests for your code and UI, but you’re not sure how to test in Xcode.\nMaybe you already have a “working” app but no tests set up for it, and you want to be able to test any changes when you extend the app. Maybe you have some tests written, but aren’t sure whether they’re the right tests. Or maybe you’re working on your app now and want to test as you go.\nThis iOS Unit Testing and UI Testing tutorial shows how to use Xcode’s test navigator to test an app’s model and asynchronous methods, how to fake interactions with library or system objects by using stubs and mocks, how to test UI and performance, and how to use the code coverage tool. Along the way, you’ll pick up some of the vocabulary used by testing ninjas, and by the end of this tutorial you’ll be injecting dependencies into your System Under Test (SUT) with aplomb!"
    let testSpanMessage = "Ican'tbelieveTweeternowsupportschunkingmymessages, so I don't have to do it myself."
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
        let longMessage = gererateLongString(multiple:10000)
        self.measure {
            // Put the code you want to measure the time of here.
            do{
                _ =  try splitMessage(message: longMessage)
            }catch MessageError.invalidLength{
                
            }catch{
                
            }
        }
    }
    func testSplitMessage(){
        let message = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expectedSplitedMessages1 = ["1/2 I can't believe Tweeter now supports chunking", "2/2 my messages, so I don't have to do it myself."]
        
        //        XCTAssertNoThrow(try splitMessage(message: message))
        XCTAssertThrowsError(try splitMessage(message: testSpanMessage))
        XCTAssertEqual(try splitMessage(message: message), expectedSplitedMessages1)
        
    }
    func testHelloWorld(){
        var helloWorld:String?
        XCTAssertNil(helloWorld)
        helloWorld = "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }
    func gererateLongString(multiple:Int) -> String{
        var messageArray = [String]()
        for _ in 0 ..< multiple{
            messageArray.append(testLongMessage)
        }
        let longMessage = messageArray.joined(separator: " ")
        return longMessage
    }
}
