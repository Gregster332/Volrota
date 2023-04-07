//
//  ProfileTableViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    
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
    
    func render(with props: ProfileViewController.ProfileProps.ProfileSettingsCell) {
        titleLabel.text = props.title
        titleLabel.textColor = props.textColor
    }
}

private extension ProfileTableViewCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .systemGray6
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .center
            $0.textColor = .black
        }
    }
    
    func addViews() {
        
        contentView.addSubviews([titleLabel])
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
