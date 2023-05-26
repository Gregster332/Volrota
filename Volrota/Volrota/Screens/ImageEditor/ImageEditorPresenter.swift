// 
//  ImageEditorPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/16/23.
//

import Foundation
import XCoordinator
import GeneralServices

protocol ImageEditorPresenterProtocol: AnyObject {
    func initialize()
    func saveFilteredImage()
}

final class ImageEditorPresenter: ImageEditorPresenterProtocol {
    
    // MARK: - Properties

    private weak var view: ImageEditorViewControllerProtocol?
    private weak var photoFilterDelagate: PhotoFilterDelegate?
    private let router: WeakRouter<ProfileRoute>
    private let database: FirebaseDatabse
    private let storage: FirebaseStorage
    
    private let originalImage: UIImage
    private var filteredImage: UIImage = UIImage()
    private let userId: String
    private lazy var imageEditor = ImageEditorServiceImpl()
    private var filters = FilterType.allCases

    // MARK: - Initialize

    init(
        view: ImageEditorViewControllerProtocol,
        delagate: PhotoFilterDelegate,
        router: WeakRouter<ProfileRoute>,
        storage: FirebaseStorage,
        database: FirebaseDatabse,
        image: UIImage,
        userId: String
    ) {
        self.view = view
        self.photoFilterDelagate = delagate
        self.router = router
        self.database = database
        self.storage = storage
        self.originalImage = image
        self.userId = userId
    }
    
    func initialize() {
        imageEditor.assignImage(image: originalImage)
        imageEditor.start()
        imageEditor.wait()
        let props = ImageEditorViewControllerProps(
            filteredImage: originalImage,
            filters: FilterType.allCases.map { $0.filterName },
            didTapOnFilter: didTapOnFilter)
        view?.render(with: props)
    }
    
    func saveFilteredImage() {
        Task(priority: .utility) {
            do {
                let imageUrl = try await storage.uploadPhoto(
                    with: userId,
                    name: "user-image",
                    image: filteredImage)
                photoFilterDelagate?.pickImage(imageUrl)
                try await database.updateUserPhotoUrl(with: userId, imageUrl)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Private Methods

private extension ImageEditorPresenter {
    
    private func didTapOnFilter(_ indexPath: IndexPath) {
        if indexPath.item == 0 {
            view?.renderImage(originalImage)
        }
        
        imageEditor.addTask(filter: filters[indexPath.item]) { [weak self] filteredImage in
            if let image = filteredImage {
                self?.filteredImage = image
                self?.view?.renderImage(image)
            }
        }
    }
}

