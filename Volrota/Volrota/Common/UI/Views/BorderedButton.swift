//
//  File.swift
//  
//
//  Created by Greg Zenkov on 2/6/23.
//

import UIKit

class BorderedButton: UIButton {
    
    required init(text: String, background: UIColor, titleColor: UIColor, lineHeight: CGFloat? = nil, fontSize: CGFloat, fontWeight: UIFont.Weight, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        setup(text: text,
              background: background,
              titleColor: titleColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              cornerRadius: cornerRadius)
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }
    
    private func setup(text: String, background: UIColor, titleColor: UIColor, lineHeight: CGFloat? = nil, fontSize: CGFloat, fontWeight: UIFont.Weight, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        backgroundColor = background
        setTitle(text, for: .normal)
        setTitleColor(titleColor, for: .normal)
//        if lineHeight == nil {
//            titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
//        } else {
//            titleLabel?.font = UIFont.rounded(ofSize: fontSize, weight: fontWeight, lineHeight: lineHeight)
//        }
    }
}
