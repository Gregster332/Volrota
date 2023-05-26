// 
//  ImageEditorBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/16/23.
//

import GeneralServices
import XCoordinator

final class ImageEditorBuilder {
    
    static func build(
        router: WeakRouter<ProfileRoute>,
        delagate: PhotoFilterDelegate,
        storage: FirebaseStorage,
        database: FirebaseDatabse,
        image: UIImage,
        userId: String
    ) -> ImageEditorViewController {
        
        let view = ImageEditorViewController()
        let presenter = ImageEditorPresenter(
            view: view,
            delagate: delagate,
            router: router,
            storage: storage,
            database: database,
            image: image,
            userId: userId)
        
        view.presenter = presenter
        return view
    }
}
