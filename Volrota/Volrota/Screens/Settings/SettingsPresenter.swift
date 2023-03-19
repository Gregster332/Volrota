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

    // MARK: - Initialize
    init(view: SettingsViewControllerProtocol, router: WeakRouter<SettingsRoute>, permissionService: PermissionService) {
        self.view = view
        self.router = router
        self.permissionService = permissionService
        addObserver()
        initialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initialize() {
        Task {
            let isAccessGranted = await permissionService.isGrantedAccess()
            let props: SettingsViewController.SettingsProps = SettingsViewController.SettingsProps(
                cells: [
                    .profileCell(
                        SettingsViewController.SettingsProps.ProfileCellProps(
                            avatarImage: Images.profileMockLogo.image,
                            userName: "Ded",
                            action: openProfile)
                    ),
                    .defaultCell(
                        SettingsViewController.SettingsProps.SettingsCellProps(
                            title: "Уведомления",
                            isToggled: true,
                            initialValue: isAccessGranted,
                            toggleAction: openAppSettings)
                    ),
                    .defaultCell(
                        SettingsViewController.SettingsProps.SettingsCellProps(
                            title: "Безопасность",
                            isToggled: false,
                            initialValue: false,
                            toggleAction: nil)
                    ),
                    .defaultCell(
                        SettingsViewController.SettingsProps.SettingsCellProps(
                            title: "Внешний вид",
                            isToggled: false,
                            initialValue: false,
                            toggleAction: nil)
                    ),
                    .defaultCell(
                        SettingsViewController.SettingsProps.SettingsCellProps(
                            title: "О нас",
                            isToggled: false,
                            initialValue: false,
                            toggleAction: nil)
                    )
//                    [
//                        SettingsViewController.SettingsProps.SettingsCellProps(
//                            title: "Уведомления",
//                            isToggled: true,
//                            initialValue: isAccessGranted,
//                            toggleAction: openAppSettings),
//                        SettingsViewController.SettingsProps.SettingsCellProps(
//                            title: "Безопасность",
//                            isToggled: false,
//                            initialValue: false,
//                            toggleAction: nil),
//                        SettingsViewController.SettingsProps.SettingsCellProps(
//                            title: "Внешний вид",
//                            isToggled: false,
//                            initialValue: false,
//                            toggleAction: nil),
//                        SettingsViewController.SettingsProps.SettingsCellProps(
//                            title: "О нас",
//                            isToggled: false,
//                            initialValue: false,
//                            toggleAction: nil),
//                    ]
                ]
            )
            DispatchQueue.main.async { [weak self] in
                self?.view?.render(with: props)
            }
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(chechNotificationAccess), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func chechNotificationAccess() {
        initialize()
    }
}
