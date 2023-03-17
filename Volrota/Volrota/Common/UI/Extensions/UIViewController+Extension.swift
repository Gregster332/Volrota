//
//  UIViewController+Extension.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import UIKit

extension UIViewController {
    
    func setupNavigationBar(with customView: UIView) {
        UINavigationBar.appearance().tintColor = Colors.accentColor.color
        UINavigationBar.appearance().isTranslucent = false
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.shadowImage = nil
            navBarAppearance.shadowColor = nil
            navBarAppearance.backgroundColor = .white
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            if #available(iOS 15.0, *) {
                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
                UINavigationBar.appearance().standardAppearance = navBarAppearance
            }
        }
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationController?.navigationBar.layer.shadowRadius = 10
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.1
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)
    }
}

