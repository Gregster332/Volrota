//
//  ProfileCoordinator.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/11/23.
//

import XCoordinator
import PhotosUI
import Utils

enum ProfileRoute: Route {
    case profile
    case dismiss
    case alert(Alert)
    case photoPicker(PHPickerViewController)
    case auth
    case imageEditor(UIImage, String, PhotoFilterDelegate)
}

final class ProfileCoordinator: NavigationCoordinator<ProfileRoute> {
    
    private var dependencies: Dependencies
    
    
    init(dependencies: Dependencies, rootViewController: UINavigationController) {
        self.dependencies = dependencies
        super.init(initialRoute: .profile)
    }
    
    override func prepareTransition(for route: ProfileRoute) -> NavigationTransition {
        switch route {
        case .profile:
            print("dsdsds")
            let profile = profile()
            return .set([profile])
        case .dismiss:
            return .dismiss()
        case .alert(let alert):
            return .presentAlert(alert)
        case .photoPicker(let photoPicker):
            return .present(photoPicker)
        case .auth:
            let auth = auth()
            return .presentFullScreen(auth)
        case .imageEditor(let image, let userId, let delegate):
            let imageEditor = imageEditor(image: image, userId: userId, delegate: delegate)
            return .push(imageEditor)
        }
    }
    
    private func profile() -> UIViewController {
        let profile = ProfileBuilder.build(
            router: weakRouter,
            authenticationService: dependencies.authenticationService,
            keyChainService: dependencies.keyChainService,
            databse: dependencies.firebaseDatabse,
            firebaseStorageService: dependencies.firebaseStorageService
        )
        return profile
    }
    
    private func auth() -> AuthCoordinator {
        let auth = AuthCoordinator(dependencies: dependencies)
        return auth
    }
    
    private func imageEditor(image: UIImage, userId: String, delegate: PhotoFilterDelegate) -> UIViewController {
        let imageEditor = ImageEditorBuilder.build(
            router: weakRouter,
            delagate: delegate,
            storage: dependencies.firebaseStorageService,
            database: dependencies.firebaseDatabse,
            image: image,
            userId: userId
        )
        return imageEditor
    }
}
