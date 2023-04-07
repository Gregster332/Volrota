//
//  TypingCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import UIKit

class TypingCell: UITableViewCell {
    
    private let textFieid = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addViews()
        setupConstraints()
    }
    
    func render(tag: Int) {
        textFieid.tag = tag
    }
}

private extension TypingCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        textFieid.do {
           // $0.delegate = self
            $0.textColor = .black
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemBlue.cgColor
            $0.layer.cornerRadius = 10
            $0.placeholder = "type..."
            $0.setLeftPaddingPoints(12)
            $0.setRightPaddingPoints(12)
        }
    }
    
    func addViews() {
        
        contentView.addSubview(textFieid)
    }
    
    func setupConstraints() {
        
        textFieid.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.verticalEdges.equalToSuperview().inset(4)
        }
    }
}

//extension TypingCell: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let nextTag = textField.tag + 1
//
//        if let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTag) {
//            nextResponder.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//
//        return true
//    }
//}
