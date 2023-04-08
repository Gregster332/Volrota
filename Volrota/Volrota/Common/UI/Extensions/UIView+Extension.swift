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
    
    func circled() {
        guard frame.size.height == frame.size.width else {
            return
        }
        self.layer.cornerRadius = frame.size.height / 2
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func animated(hide: Bool) {
        UIView.transition(with: self, duration: 1, options: .curveLinear, animations: {
            self.isHidden = hide
        })
    }
    
    func getViewsByTag(tag:Int) -> Array<UIView?>{
        return subviews.filter { ($0 as UIView).tag == tag } as [UIView]
    }
}
