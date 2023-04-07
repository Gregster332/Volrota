//
//  SettingsTableViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    private var toggleCompletion: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    
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
    
    func render(with props: SettingsViewController.SettingsProps.SettingsCellProps) {
        titleLabel.text = props.title
        toggle.isHidden = !props.isToggled
        toggle.isOn = props.initialValue
        toggleCompletion = props.toggleAction
    }
}

private extension SettingsTableViewCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .systemGray6
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.textAlignment = .left
            $0.textColor = .black
        }
        
        toggle.do {
            $0.addTarget(self, action: #selector(handleToggle), for: .valueChanged)
        }
    }
    
    func addViews() {
        
        contentView.addSubviews([titleLabel, toggle])
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        toggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func handleToggle() {
        toggleCompletion?()
    }
}
