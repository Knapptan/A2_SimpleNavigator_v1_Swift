
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
