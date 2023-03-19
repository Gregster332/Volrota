//
//  ProfileSettingsCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import UIKit

class ProfileSettingsCell: UITableViewCell {
    
    private let avatarImage = UIImageView()
    private let userNameLabel = UILabel()
    
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
    
    func render(with props: SettingsViewController.SettingsProps.ProfileCellProps) {
        avatarImage.image = props.avatarImage
        userNameLabel.text = props.userName
    }
}

private extension ProfileSettingsCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .systemGray6
        }
        
        avatarImage.do {
            $0.layer.cornerRadius = 20
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
        }
        
        userNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
        }
    }
    
    func addViews() {
        
        contentView.addSubviews([avatarImage, userNameLabel])
    }
    
    func setupConstraints() {
        
        avatarImage.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImage.snp.bottom).offset(8)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
    }
}
