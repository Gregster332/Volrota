//
//  OrganizationCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/28/23.
//

import UIKit
import Utils

class OrganizationCell: UICollectionViewCell {
    
    // MARK: - Views
    private let organizationImageView = UIImageView()
    private let organizationTitleLabel = UILabel()
    
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
    func render(with props: ProfileViewControllerProps.OrganizationCell) {
        //organizationImageView.kf.setImage(with: URL(string: props.organizationImageUrl))
        //organizationImageView.kf.setImage(with: URL(string: props.organizationImageUrl))
        organizationTitleLabel.text = props.organizationName
        //organizationNameLabel.text = props.organizationName
    }
}

// MARK: - Private Methods
private extension OrganizationCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 14
        }
        
        organizationImageView.do {
            //$0.kf.indicatorType = .activity
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
        
        organizationTitleLabel.do {
            $0.text = " "
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.rounded(ofSize: 18, weight: .semibold)
        }
    }
    
    func addViews() {
        contentView.addSubview(organizationImageView)
        contentView.addSubview(organizationTitleLabel)
    }
    
    func setupConstraints() {
        organizationImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(150)
        }
        
        organizationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(organizationImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

