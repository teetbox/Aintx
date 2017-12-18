//
//  DataStructureTests.swift
//  AintxTests
//
//  Created by Matt Tian on 18/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class DataStructureTests: XCTestCase {
    
    func testNode() {
        let node5 = Node(value: 5)
        
        XCTAssertNil(node5.next)
        XCTAssertNil(node5.previous)

        let node7 = Node(value: 7)
        node5.next = node7
       
        XCTAssertNotNil(node5.next)
        XCTAssertNil(node5.previous)
        
        let node3 = Node(value: 3)
        node5.previous = node3
        
        XCTAssertNotNil(node5.next)
        XCTAssertNotNil(node5.previous)
    }
    
    func testLinkedList() {
        var list = LinkedList<Int>()

        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        
        list.add(7)
        XCTAssertNotNil(list.head)
        XCTAssertNotNil(list.tail)
        XCTAssertFalse(list.isEmpty)
    }
    
    func testQueue() {
        let queue = Queue<Int>()
        
        queue.enqueue(5)
        
        
    }
    
}
