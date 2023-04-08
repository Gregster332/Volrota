// 
//  SettingsPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import XCoordinator

protocol SettingsPresenterProtocol: AnyObject {
    func initialize()
}

final class SettingsPresenter: SettingsPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: SettingsViewControllerProtocol?
    private let router: WeakRouter<SettingsRoute>
    private let permissionService: PermissionService
    private let database: FirebaseDatabse
    private let authenticationService: AuthService

    // MARK: - Initialize
    init(view: SettingsViewControllerProtocol, router: WeakRouter<SettingsRoute>, permissionService: PermissionService, database: FirebaseDatabse, authenticationService: AuthService) {
        self.view = view
        self.router = router
        self.permissionService = permissionService
        self.database = database
        self.authenticationService = authenticationService
        addObserver()
        initialize()
    }
    
    func initialize() {
        Task {
            let isAccessGranted = await permissionService.isGrantedAccess()
            do {
                let user = try await database.getUserInfo(by: authenticationService.currentUser?.uid ?? "")
                
                let props: SettingsProps = SettingsProps(
                    cells: [
                        .profileCell(
                            SettingsProps.ProfileCellProps(
                                avatarImageUrl: user.profileImageUrl,
                                userFullName: user.name + " " + user.secondName,
                                action: openProfile)
                        ),
                        .defaultCell(
                            SettingsProps.SettingsCellProps(
                                title: Strings.Settings.notifications,
                                isToggled: true,
                                initialValue: isAccessGranted,
                                toggleAction: openAppSettings)
                        ),
                        .defaultCell(
                            SettingsProps.SettingsCellProps(
                                title: Strings.Settings.security,
                                isToggled: false,
                                initialValue: false,
                                toggleAction: nil)
                        ),
                        .defaultCell(
                            SettingsProps.SettingsCellProps(
                                title: Strings.Settings.appearance,
                                isToggled: false,
                                initialValue: false,
                                toggleAction: nil)
                        ),
                        .defaultCell(
                            SettingsProps.SettingsCellProps(
                                title: Strings.Settings.about,
                                isToggled: false,
                                initialValue: false,
                                toggleAction: nil)
                        )
                    ]
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.render(with: props)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func viewWillDisappaer() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Methods
private extension SettingsPresenter {
    
    func openAppSettings() {
        router.trigger(.appSettings)
    }
    
    func openProfile() {
        router.trigger(.profile)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(chechNotificationAccess),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func chechNotificationAccess() {
        initialize()
    }
}
