//
//  ImageEditorService.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/16/23.
//

import UIKit

enum FilterType: CaseIterable {
    
    case original
    case falseColor
    case colorPosterize
    case vignette
    case sepiaTone
    case process
    case tonal
    case transfer
    
    var filterName: String {
        switch self {
        case .original:
            return "Оригинал"
        case .falseColor:
            return "Инверсия"
        case .colorPosterize:
            return "Постеризация"
        case .vignette:
            return "Виньетка"
        case .sepiaTone:
            return "Нуар"
        case .process:
            return "Сепия"
        case .tonal:
            return "Тон"
        case .transfer:
            return "Трансфер"
        }
    }
    
    var filter: CIFilter? {
        switch self {
        case .original:
            return nil
        case .falseColor:
            return CIFilter(name: "CIFalseColor")
        case .colorPosterize:
            return CIFilter(name: "CIColorPosterize")
        case .vignette:
            return CIFilter(name: "CIVignette")
        case .sepiaTone:
            return CIFilter(name: "CISepiaTone")
        case .process:
            return CIFilter(name: "CIPhotoEffectProcess")
        case .tonal:
            return CIFilter(name: "CIPhotoEffectTonal")
        case .transfer:
            return CIFilter(name: "CIPhotoEffectTransfer")
        }
    }
}

final class ImageEditorServiceImpl {
    
    private let queue = OperationQueue()
    private var inputImage: UIImage?
    
    init() {
        queue.isSuspended = true
        queue.maxConcurrentOperationCount = 1
    }
    
    func assignImage(image: UIImage?) {
        inputImage = image
    }
    
    func addTask(filter: FilterType, completion: @escaping (UIImage?) -> Void) {
        let filterImage = FilterOperation(
            inputImage: inputImage,
            filter: filter
        )
        
        filterImage.completionBlock = {
            OperationQueue.main.addOperation {
                completion(filterImage.filteredImage)
            }
        }
        queue.addOperation(filterImage)
    }
    
    func start() {
        queue.isSuspended = false
    }

    func cancelAll() {
        queue.cancelAllOperations()
    }

    func wait() {
        queue.waitUntilAllOperationsAreFinished()
    }
}

class FilterOperation: AsyncOperation {
    private let _inputImage: UIImage?
    private let _filter: FilterType
    var filteredImage: UIImage?

    init(inputImage: UIImage?, filter: FilterType) {
        _inputImage = inputImage
        _filter = filter
        super.init()
    }

    var inputImage: UIImage? {
        return _inputImage
    }

    override func main() {
        inputImage?.applyFilterForImage(
            filter: _filter
        ) { [weak self] image in
            self?.filteredImage = image
            self?.state = .finished
        }
    }
}

class AsyncOperation: Operation {

    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }

    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        } didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override var isAsynchronous: Bool {
        return true
    }

    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override func start() {
        if isCancelled {
            state = .finished
            return
        }

        main()
        state = .executing
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }
}
