//
//  TestJSONSerialization.swift
//  SwiftFoundation
//
//  Created by Alexandra Wishart on 30/10/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#if DEPLOYMENT_RUNTIME_OBJC || os(Linux)
    import Foundation
    import XCTest
#else
    import SwiftFoundation
    import SwiftXCTest
#endif


extension TestJSONSerialization {
    static var allTests : [(String, (TestJSONSerialization) -> () throws -> Void)] {
    return [
    ("test_json_serialization", test_jsonSerialization)
    ]
    }
}

class TestJSONSerialization : XCTestCase {
    func test_jsonSerialization() {
        
        let numItems = 20                  // Number of elements in the payload
        let loops = 500                    // Number of times to invoke serialization per measurement
        let concurrency = 4                // Number of concurrent threads
        var PAYLOAD = [String:Any]()       // The string to convert
        
        for i in 1...numItems {
            PAYLOAD["Item \(i)"] = Double(i)
        }
        
        let queue = DispatchQueue(label: "testcaseQueue", attributes: .concurrent)
        let group = DispatchGroup()
        
        self.measure {
            for _ in 1...concurrency {
                queue.async(group: group) {
                    for _ in 1...loops {
                        do {
                            _ = try JSONSerialization.data(withJSONObject: PAYLOAD)
                        } catch {
                            XCTFail("Could not serialize to JSON: \(error)")
                        }
                    }
                }
            }
            _ = group.wait(timeout: .distantFuture) // forever
        }
    }
}


