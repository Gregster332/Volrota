//
//  Transition.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

extension Transition {
    
    static func presentFullScreen(_ presentable: Presentable) -> Transition {
        presentable.viewController?.modalPresentationStyle = .fullScreen
        return .present(presentable)
    }
    
    static func appSettings() -> Transition {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return .none()
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
        return .none()
    }
    
    static func dismissAndReload(animation: Animation? = nil) -> Transition {
        Transition(presentables: [],
                   animationInUse: animation?.dismissalAnimation) { rootViewController, _, _ in
            rootViewController.presentingViewController?.viewWillAppear(true)
            rootViewController.dismiss(animated: true)
        }
    }
    
    static func presentAlert(_ alert: Alert) -> Transition {
        let actions = alert.actions.map { alert in
            UIAlertAction(
                title: alert.title,
                style: alert.style
            ) { _ in alert.action?() }
        }
        let alert = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: alert.style
        )
        actions.forEach { alert.addAction($0) }
        return .present(alert)
    }
    
}
