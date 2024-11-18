import Foundation

// MARK: - Задание 1: Реализация динамических массивов

protocol DynamicArray {
    associatedtype T
    func add(item: T, at index: Int)
    func remove(at index: Int) -> T
}

class SingleArray<T>: DynamicArray {
    private var array: [T?] = []

    func add(item: T, at index: Int) {
        if index < 0 || index > array.count {
            fatalError("Index out of bounds")
        }
        array.insert(item, at: index)
    }

    func remove(at index: Int) -> T {
        if index < 0 || index >= array.count {
            fatalError("Index out of bounds")
        }
        return array.remove(at: index)!
    }
}

class VectorArray<T>: DynamicArray {
    private var array: [T?] = []
    private let vectorSize: Int
    private var capacity: Int

    init(vectorSize: Int) {
        self.vectorSize = vectorSize
        self.capacity = vectorSize
    }

    func add(item: T, at index: Int) {
        if index < 0 || index > array.count {
            fatalError("Index out of bounds")
        }
        if array.count >= capacity {
            capacity += vectorSize
            array += Array(repeating: nil, count: vectorSize)
        }
        array.insert(item, at: index)
    }

    func remove(at index: Int) -> T {
        if index < 0 || index >= array.count {
            fatalError("Index out of bounds")
        }
        return array.remove(at: index)!
    }
}

class FactorArray<T> {
    private var array: [T?] = []
    private var count = 0
    private var capacity = 1

    func add(item: T, at index: Int) {
        if index < 0 || index > count {
            fatalError("Index out of bounds")
        }
        if count >= capacity {
            // Увеличиваем емкость в 1.5 раза и гарантируем, что она больше текущего размера
            capacity = max(capacity * 3 / 2, count + 1)
            var newArray = Array<T?>(repeating: nil, count: capacity)
            for i in 0..<array.count {
                newArray[i] = array[i]
            }
            array = newArray
        }
        array.insert(item, at: index)
        count += 1
    }

    func remove(at index: Int) -> T {
        if index < 0 || index >= count {
            fatalError("Index out of bounds")
        }
        let removedItem = array[index]!
        array.remove(at: index)
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
        if index < 0 || index > size {
            fatalError("Index out of bounds")
        }

        if size == arrays.count * matrixSize {
            // Когда массив заполнен, добавляем новый подмассив
            arrays.append([T?](repeating: nil, count: matrixSize))
        }

        // Вычисляем индексы подмассива и позиции в нем
        let rowIndex = size / matrixSize
        let colIndex = size % matrixSize

        arrays[rowIndex][colIndex] = item
        size += 1
    }

    func remove(at index: Int) -> T {
        if index < 0 || index >= size {
            fatalError("Index out of bounds")
        }

        // Находим индексы строки и столбца
        let rowIndex = index / matrixSize
        let colIndex = index % matrixSize

        let item = arrays[rowIndex][colIndex]!
        arrays[rowIndex][colIndex] = nil
        size -= 1
        
        return item
    }
}

class ArrayList<T>: DynamicArray {
    private var array: [T] = []
    
    func add(item: T, at index: Int) {
        if index < 0 || index > array.count {
            fatalError("Index out of bounds")
        }
        array.insert(item, at: index)
    }

    func remove(at index: Int) -> T {
        if index < 0 || index >= array.count {
            fatalError("Index out of bounds")
        }
        return array.remove(at: index)
    }
}

// MARK: - Задание 2: Таблица сравнения производительности

func measureExecutionTime(operation: () -> Void) -> Double {
    let start = DispatchTime.now()
    operation()
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    return Double(nanoTime) / 1_000_000 // время в миллисекундах
}

let elementsCountArray = [10, 100, 1000, 5000]

// Для хранения результатов
var results: [(numberOfElements: Int, arrayListTime: Double, singleArrayTime: Double, vectorArrayTime: Double, factorArrayTime: Double, matrixArrayTime: Double)] = []

for numberOfElements in elementsCountArray {
    // Создаем новые экземпляры массивов для каждого измерения
    let arrayList = ArrayList<Int>()
    let singleArray = SingleArray<Int>()
    let vectorArray = VectorArray<Int>(vectorSize: 10)
    let factorArray = FactorArray<Int>()
    let matrixArray = MatrixArray<Int>(matrixSize: 10)

    // Замеры для ArrayList
    let executionTimeArrayList = measureExecutionTime {
        for i in 0..<numberOfElements {
            arrayList.add(item: i, at: i)
        }
    }

    // Замеры для SingleArray
    let executionTimeSingleArray = measureExecutionTime {
        for i in 0..<numberOfElements {
            singleArray.add(item: i, at: i)
        }
    }

    // Замеры для VectorArray
    let executionTimeVectorArray = measureExecutionTime {
        for i in 0..<numberOfElements {
            vectorArray.add(item: i, at: i)
        }
    }

    // Замеры для FactorArray
    let executionTimeFactorArray = measureExecutionTime {
        for i in 0..<numberOfElements {
            factorArray.add(item: i, at: i)
        }
    }

    // Замеры для MatrixArray
    let executionTimeMatrixArray = measureExecutionTime {
        for i in 0..<numberOfElements {
            matrixArray.add(item: i, at: i)
        }
    }

    // Сохраняем результаты для этого числа элементов
    results.append((numberOfElements, executionTimeArrayList, executionTimeSingleArray, executionTimeVectorArray, executionTimeFactorArray, executionTimeMatrixArray))
}

// Выводим таблицу с результатами
print("Таблица времени выполнения для разных значений numberOfElements, в мс:")
print("Элементов\t| ArrayList \t| SingleArray \t| VectorArray \t| FactorArray \t| MatrixArray ")
for result in results {
    print("\(result.numberOfElements)\t| \(String(format: "%.2f", result.arrayListTime))\t| \(String(format: "%.2f", result.singleArrayTime))\t| \(String(format: "%.2f", result.vectorArrayTime))\t| \(String(format: "%.2f", result.factorArrayTime))\t| \(String(format: "%.2f", result.matrixArrayTime))")
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
