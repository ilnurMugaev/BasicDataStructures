import Foundation

// MARK: - Задание 1: Реализация динамических массивов


protocol DynamicArray {
    associatedtype T
    func add(item: T, at index: Int)
    func remove(at index: Int) -> T?
}

class SingleArray<T>: DynamicArray {
    private var array: [T?] = []
    
    func add(item: T, at index: Int) {
        guard index >= 0, index <= array.count else { return }
        
        var newArray = [T?](repeating: nil, count: array.count + 1)
        for i in 0..<index {
            newArray[i] = array[i]
        }
        newArray[index] = item
        for i in index..<array.count {
            newArray[i + 1] = array[i]
        }
        array = newArray
    }
    
    func remove(at index: Int) -> T? {
        guard index >= 0, index < array.count else { return nil }
        
        let removedItem = array[index]
        var newArray = [T?](repeating: nil, count: array.count - 1)
        for i in 0..<index {
            newArray[i] = array[i]
        }
        for i in (index + 1)..<array.count {
            newArray[i - 1] = array[i]
        }
        array = newArray
        return removedItem
    }
}

class VectorArray<T>: DynamicArray {
    private var array: [T?] = []
    private let vectorSize: Int
    private var capacity: Int

    init(vectorSize: Int) {
        self.vectorSize = vectorSize
        self.capacity = vectorSize
        array = [T?](repeating: nil, count: capacity)
    }

    func add(item: T, at index: Int) {
        guard index >= 0, index <= array.count else { return }

        if array.count >= capacity {
            capacity += vectorSize
            array += [T?](repeating: nil, count: vectorSize)
        }

        var newArray = [T?](repeating: nil, count: array.count + 1)
        for i in 0..<index {
            newArray[i] = array[i]
        }
        newArray[index] = item
        for i in index..<array.count {
            newArray[i + 1] = array[i]
        }
        array = newArray
    }

    func remove(at index: Int) -> T? {
        guard index >= 0, index < array.count else { return nil }

        let removedItem = array[index]
        var newArray = [T?](repeating: nil, count: array.count - 1)
        for i in 0..<index {
            newArray[i] = array[i]
        }
        for i in (index + 1)..<array.count {
            newArray[i - 1] = array[i]
        }
        array = newArray
        return removedItem
    }
}

class FactorArray<T> {
    private var array: [T?] = []
    private var count = 0
    private var capacity = 1

    func add(item: T, at index: Int) {
        guard index >= 0, index <= count else { return }

        if count >= capacity {
            capacity = max(capacity * 3 / 2, count + 1)
            var newArray = [T?](repeating: nil, count: capacity)
            for i in 0..<array.count {
                newArray[i] = array[i]
            }
            array = newArray
        }

        var newArray = [T?](repeating: nil, count: array.count + 1)
        for i in 0..<index {
            newArray[i] = array[i]
        }
        newArray[index] = item
        for i in index..<array.count {
            newArray[i + 1] = array[i]
        }
        array = newArray
        count += 1
    }

    func remove(at index: Int) -> T? {
        guard index >= 0, index < count else { return nil }

        let removedItem = array[index]
        var newArray = [T?](repeating: nil, count: array.count - 1)
        for i in 0..<index {
            newArray[i] = array[i]
        }
        for i in (index + 1)..<array.count {
            newArray[i - 1] = array[i]
        }
        array = newArray
        count -= 1
        return removedItem
    }
}

class MatrixArray<T>: DynamicArray {
    private var arrays: [[T?]] = []
    private let matrixSize: Int
    private var size: Int = 0

    init(matrixSize: Int) {
        self.matrixSize = matrixSize
    }

    func add(item: T, at index: Int) {
        guard index >= 0, index <= size else { return }

        if size == arrays.count * matrixSize {
            arrays.append([T?](repeating: nil, count: matrixSize))
        }

        let rowIndex = size / matrixSize
        let colIndex = size % matrixSize

        arrays[rowIndex][colIndex] = item
        size += 1
    }

    func remove(at index: Int) -> T? {
        guard index >= 0, index < size else { return nil }

        let rowIndex = index / matrixSize
        let colIndex = index % matrixSize

        let item = arrays[rowIndex][colIndex]
        arrays[rowIndex][colIndex] = nil
        size -= 1

        return item
    }
}

class ArrayList<T>: DynamicArray {
    private var array: [T] = []

    func add(item: T, at index: Int) {
        guard index >= 0, index <= array.count else { return }
        array.insert(item, at: index)
    }

    func remove(at index: Int) -> T? {
        guard index >= 0, index < array.count else { return nil }
        return array.remove(at: index)
    }
}

// MARK: - Задание 2: Таблица сравнения производительности

func measureExecutionTime(operation: () -> Void) -> Double {
    let start = DispatchTime.now()
    operation()
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    return Double(nanoTime) / 1_000_000
}

let elementsCountArray = [10, 100, 1000, 2000]

print("\nТаблица времени выполнения (в миллисекундах):\n")
print([
    "Элементов".padding(toLength: 10, withPad: " ", startingAt: 0),
    "ArrayList".padding(toLength: 12, withPad: " ", startingAt: 0),
    "SingleArray".padding(toLength: 12, withPad: " ", startingAt: 0),
    "VectorArray".padding(toLength: 12, withPad: " ", startingAt: 0),
    "FactorArray".padding(toLength: 12, withPad: " ", startingAt: 0),
    "MatrixArray".padding(toLength: 12, withPad: " ", startingAt: 0)
].joined(separator: " | "))

for numberOfElements in elementsCountArray {
    autoreleasepool {
        let arrayList = ArrayList<Int>()
        let singleArray = SingleArray<Int>()
        let vectorArray = VectorArray<Int>(vectorSize: 10)
        let factorArray = FactorArray<Int>()
        let matrixArray = MatrixArray<Int>(matrixSize: 10)
        
        let executionTimeArrayList = measureExecutionTime {
            autoreleasepool {
                for i in 0..<numberOfElements {
                    arrayList.add(item: i, at: i)
                }
            }
        }
        
        let executionTimeSingleArray = measureExecutionTime {
            autoreleasepool {
                for i in 0..<numberOfElements {
                    singleArray.add(item: i, at: i)
                }
            }
        }
        
        let executionTimeVectorArray = measureExecutionTime {
            autoreleasepool {
                for i in 0..<numberOfElements {
                    vectorArray.add(item: i, at: i)
                }
            }
        }
        
        let executionTimeFactorArray = measureExecutionTime {
            autoreleasepool {
                for i in 0..<numberOfElements {
                    factorArray.add(item: i, at: i)
                }
            }
        }
        
        let executionTimeMatrixArray = measureExecutionTime {
            autoreleasepool {
                for i in 0..<numberOfElements {
                    matrixArray.add(item: i, at: i)
                }
            }
        }
        
        let row = [
            String(numberOfElements).padding(toLength: 10, withPad: " ", startingAt: 0),
            String(format: "%.2f", executionTimeArrayList).padding(toLength: 12, withPad: " ", startingAt: 0),
            String(format: "%.2f", executionTimeSingleArray).padding(toLength: 12, withPad: " ", startingAt: 0),
            String(format: "%.2f", executionTimeVectorArray).padding(toLength: 12, withPad: " ", startingAt: 0),
            String(format: "%.2f", executionTimeFactorArray).padding(toLength: 12, withPad: " ", startingAt: 0),
            String(format: "%.2f", executionTimeMatrixArray).padding(toLength: 12, withPad: " ", startingAt: 0)
        ].joined(separator: " | ")
        
        print(row)
    }
}

// MARK: - Задание 3: Приоритетная очередь

class PriorityQueue<T> {
    private var elements: [(priority: Int, item: T)] = []

    func enqueue(priority: Int, item: T) {
        elements.append((priority, item))
        elements.sort { $0.priority > $1.priority }
    }

    func dequeue() -> T? {
        return elements.isEmpty ? nil : elements.removeFirst().item
    }
}

let priorityQueue = PriorityQueue<String>()
priorityQueue.enqueue(priority: 2, item: "Low priority")
priorityQueue.enqueue(priority: 5, item: "High priority")
if let item = priorityQueue.dequeue() {
    print("Извлечён элемент с приоритетом: \(item)")
}

// MARK: - Задание 4: SpaceArray

class SpaceArray<T> {
    private var arrays: [[T]] = []
    private let spaceSize: Int

    init(spaceSize: Int) {
        self.spaceSize = spaceSize
        arrays.append([])
    }

    func add(item: T) {
        if arrays[arrays.count - 1].count >= spaceSize {
            arrays.append([])
        }
        arrays[arrays.count - 1].append(item)
    }

    func get(at index: Int) -> T? {
        let arrayIndex = index / spaceSize
        let itemIndex = index % spaceSize
        return arrayIndex < arrays.count ? arrays[arrayIndex][itemIndex] : nil
    }
}

let spaceArray = SpaceArray<Int>(spaceSize: 5)
spaceArray.add(item: 10)
spaceArray.add(item: 20)
print("Элемент по индексу 1: \(spaceArray.get(at: 1) ?? -1)")
