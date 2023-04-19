//
//  ActualDescriptionCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/12/23.
//

import UIKit

class ActualDescriptionCell: UITableViewCell {
    
    private let background = UIView()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func render(with description: String) {
        descriptionLabel.text = description
    }
}


private extension ActualDescriptionCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        background.do {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 16
        }
        
        descriptionLabel.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(background)
        contentView.addSubview(descriptionLabel)
        
        background.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.edges.equalTo(background).inset(8)
        }
    }
}

