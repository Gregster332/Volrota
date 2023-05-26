//
//  AddEventTitleCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/25/23.
//

import UIKit

class AddEventTitleCell: UICollectionViewCell {
    
    private let titleTextFiled = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func setupTextFiledDelegate(_ delegate: UITextFieldDelegate?) {
        titleTextFiled.delegate = delegate
    }
}

private extension AddEventTitleCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        titleTextFiled.do {
            $0.placeholder = Strings.AddNewEvent.title
            $0.backgroundColor = .systemGray6
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
            view.backgroundColor = .clear
            $0.leftViewMode = .always
            $0.leftView = view
            $0.layer.cornerRadius = 12
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(titleTextFiled)
        
        titleTextFiled.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(44)
        }
    }
}
