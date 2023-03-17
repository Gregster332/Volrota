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

    // MARK: - Initialize
    init(view: SettingsViewControllerProtocol, router: WeakRouter<SettingsRoute>) {
        self.view = view
        self.router = router
        initialize()
    }
    
    func initialize() {
        let props: SettingsViewController.SettingsProps = SettingsViewController.SettingsProps(
            cells: [
                SettingsViewController.SettingsProps.SettingsCellProps(
                    title: "Уведомления",
                    isToggled: true,
                    initialValue: true,
                    toggleAction: printSome),
                SettingsViewController.SettingsProps.SettingsCellProps(
                    title: "Безопасность",
                    isToggled: false,
                    initialValue: false,
                    toggleAction: nil),
                SettingsViewController.SettingsProps.SettingsCellProps(
                    title: "Внешний вид",
                    isToggled: false,
                    initialValue: false,
                    toggleAction: nil),
            ]
        )
        view?.render(with: props)
    }
}

// MARK: - Private Methods
private extension SettingsPresenter {
    
    func printSome(bool: Bool) {
        print("==========\(bool)")
    }
}
