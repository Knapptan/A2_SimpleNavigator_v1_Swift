//
//  s21_priorityQueue.swift
//  A2_SimpleNavigator_Swift
//
//  Created by Knapptan on 17.06.2024.
//

import Foundation

// Приоритетная очередь, сортируется по дистанции
struct PriorityQueue<Element: Equatable & Hashable> {
    private var elements: [(element: Element, priority: Int)] = []
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    mutating func enqueue(_ element: Element, priority: Int) {
        elements.append((element, priority))
        elements.sort { $0.priority < $1.priority }
    }
    
    mutating func dequeue() -> Element? {
        return isEmpty() ? nil : elements.removeFirst().element
    }
}

// Описание типа кортежа в массиве протоколы Equatable и Hashable
struct VertexDistance: Equatable, Hashable {
    let vertex: Int
    let distance: Int
}

func ==(lhs: VertexDistance, rhs: VertexDistance) -> Bool {
    return lhs.vertex == rhs.vertex && lhs.distance == rhs.distance
}
