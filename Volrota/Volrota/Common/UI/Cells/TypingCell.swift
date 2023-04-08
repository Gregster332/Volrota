//
//  TypingCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import UIKit

struct TypingCellProps {
    let tag: Int
    let placeholder: String
}

class TypingCell: UITableViewCell {
    
    // MARK: - Views
    private let textFieid = UITextField()
    
    // MARK: - Initialize
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
    
    // MARK: - Methods
    func render(with props: TypingCellProps?) {
        textFieid.tag = props?.tag ?? 0
        textFieid.placeholder = props?.placeholder
    }
}

// MARK: - Private Methods
private extension TypingCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        textFieid.do {
            $0.textColor = .black
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemBlue.cgColor
            $0.layer.cornerRadius = 10
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
