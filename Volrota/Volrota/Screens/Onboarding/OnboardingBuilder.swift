// 
//  OnboardingBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import XCoordinator
import GeneralServices

final class OnboardingBuilder {
    
    static func build(
        router: WeakRouter<RootRoute>,
        permissionService: PermissionService,
        locationService: PermissionService,
        applicationState: ApplicationState,
        authenticationService: AuthService,
        remoteConfigService: FirebaseRemoteConfig
    ) -> OnboardingViewController {
        
        let view = OnboardingViewController()
        let presenter = OnboardingPresenter(
            view: view,
            router: router,
            permissionService: permissionService,
            locationService: locationService,
            applicationState: applicationState,
            remoteConfigService: remoteConfigService
        )
        
        view.presenter = presenter
        return view
    }
}
