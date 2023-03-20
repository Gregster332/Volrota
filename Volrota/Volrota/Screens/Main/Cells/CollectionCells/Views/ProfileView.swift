//
//  ProfileView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import SnapKit

class ProfileView: UIButton {
    
    private let avatarView = UIImageView()
    private let plusImage = UIImageView()
    private let navTitleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
        addViews()
        setupConstraints()
        avatarView.bringSubviewToFront(plusImage)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addViews()
        setupConstraints()
        avatarView.bringSubviewToFront(plusImage)
    }
    
    func setNavTitle(_ title: String) {
        navTitleLabel.text = title
    }
}

private extension ProfileView {
    
    func setupView() {
        
        avatarView.do {
            $0.image = Images.profileMockLogo.image
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 35 / 2
            $0.layer.masksToBounds = true
        }
        
        plusImage.do {
            $0.image = Images.plusAvatarImage.image
            $0.contentMode = .scaleAspectFill
        }
        
        navTitleLabel.do {
            $0.text = "Иван"
            $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .left
        }
    }
    
    func addViews() {
        
        view.addSubviews(
            [avatarView, navTitleLabel]
        )
        
        avatarView.addSubviews(
            [plusImage]
        )
    }
    
    func setupConstraints() {
        
        avatarView.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        plusImage.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.trailing.bottom.equalToSuperview()
        }
        
        navTitleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(avatarView.snp.trailing).offset(5)
        }
    }
}


