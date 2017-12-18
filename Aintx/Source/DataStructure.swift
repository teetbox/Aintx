//
//  DataStructure.swift
//  Aintx
//
//  Created by Matt Tian on 18/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public class Node<T> {
    
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?

    init(value: T) {
        self.value = value
    }
    
}

public struct LinkedList<T> {
    
    public var head: Node<T>?
    public var tail: Node<T>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public mutating func add(_ element: T) {
        let newNode = Node(value: element)
        
        if let tailNode = tail {
            tailNode.next = newNode
            newNode.previous = tailNode
        } else {
            head = newNode
        }
        
        tail = newNode
    }
    
}

public struct Queue<T> {
    
    public func enqueue(_ element: T) {
        
    }
    

}
