//
//  File.swift
//  
//
//  Created by Greg Zenkov on 2/6/23.
//

import UIKit

extension UIFont {
    
    static func rounded(ofSize fontSize: CGFloat, weight: UIFont.Weight, lineHeight: CGFloat? = nil) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return .systemFont(ofSize: fontSize, weight: weight)
        }
    }
}
