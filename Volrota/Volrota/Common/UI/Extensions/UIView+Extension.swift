//
//  UIView+Extension.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
