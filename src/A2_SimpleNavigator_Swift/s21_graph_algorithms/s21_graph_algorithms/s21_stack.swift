import Foundation

struct Stack<Element> {
    private var elements: [Element] = []
    
    // Создание пустого стека
    init() {}
    
    // Проверка, пуст ли стек
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    // Добавление элемента на вершину стека
    mutating func push(_ value: Element){
        elements.append(value)
    }
    
    // Удаление элемента с вершины стека
    @discardableResult
    mutating func pop() -> Element? {
        return elements.popLast()
    }
    
    // Получение с вершины стека без его удаления
    func top() -> Element? {
        return elements.last
    }
    
    // Получение количества элементов в стеке
    func count() -> Int {
        return elements.count
    }
    
}
