//
//  OptionsViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import UIKit

class OptionsViewCell: UICollectionViewCell {
    
    // MARK: - Views
    private let titleLabel = UILabel()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    func render(with props: ProfileViewControllerProps.ProfileSettingsCell) {
        titleLabel.text = props.title
        titleLabel.textColor = props.textColor
    }
}

// MARK: - Private Methods
private extension OptionsViewCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 12
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .left
            $0.textColor = .black
        }
    }
    
    func addViews() {
        contentView.addSubviews([titleLabel])
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
