//
//  ProfileView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import Kingfisher

struct ProfileViewProps {
    let navTitle: String
    let profileImageUrl: String
    let profileTapCompletion: (() -> Void)?
}

class ProfileView: UIButton {
    
    private var profileTapCompletion: (() -> Void)?
    
    private let avatarView = UIImageView()
    private let navTitleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
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
    
    func render(with props: ProfileViewProps?) {
        navTitleLabel.text = props?.navTitle
        avatarView.kf.setImage(with: URL(string: props?.profileImageUrl ?? ""))
        profileTapCompletion = props?.profileTapCompletion
    }
}

private extension ProfileView {
    
    func setupView() {
        
        self.do {
            $0.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        }
        
        avatarView.do {
            $0.image = Images.profileMockLogo.image
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 35 / 2
            $0.layer.masksToBounds = true
            $0.kf.indicatorType = .activity
        }
        
        navTitleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .left
        }
    }
    
    func addViews() {
        
        view.addSubviews(
            [avatarView, navTitleLabel]
        )
    }
    
    func setupConstraints() {
        
        avatarView.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        navTitleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(avatarView.snp.trailing).offset(5)
        }
    }
    
    @objc func handleTap() {
        profileTapCompletion?()
    }
}


