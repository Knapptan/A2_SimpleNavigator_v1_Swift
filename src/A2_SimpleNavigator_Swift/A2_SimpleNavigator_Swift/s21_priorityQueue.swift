//
//  s21_priorityQueue.swift
//  A2_SimpleNavigator_Swift
//
//  Created by Knapptan on 17.06.2024.
//

import Foundation

struct PriorityQueue<Element> {
    private var elements: [Element] = []
    private let priorityFunction: (Element,Element) -> Bool
    
    init(priorityFunction: @escaping (Element,Element) -> Bool) {
        self.priorityFunction = priorityFunction
    }
    
    mutating func enqueue(_ element: Element){
        elements.append(element)
        elements.sort(by: priorityFunction)
    }
    
    mutating func dequeue() -> Element? {
        return elements.isEmpty ? nil : elements.removeFirst()
    }
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
}
