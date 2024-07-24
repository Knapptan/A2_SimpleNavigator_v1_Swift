import Foundation

struct Queue<Element> {
    private var elements: [Element] = []
    
    // Создание пустой очереди
    init() {}
    
    // Проверка, пуста ли очередь
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    // Добавление элемента в конец очереди
    mutating func push(_ value: Element){
        elements.append(value)
    }
    
    // Удаление элемента из начала очереди
    @discardableResult
    mutating func pop() -> Element? {
        return elements.removeFirst()
    }
    
    // Получение первого элемента из очереди без его удаления из очереди
    func front() -> Element? {
        return elements.first
    }
    
    // Получение последнего элемента из очереди без его удаления из очереди
    func back() -> Element? {
        return elements.last
    }
    
    // Получение количества элементов в очереди
    func count() -> Int {
        return elements.count
    }
    
}
