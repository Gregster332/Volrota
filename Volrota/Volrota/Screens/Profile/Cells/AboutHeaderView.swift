//
//  AboutTableViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/3/23.
//

import Kingfisher

class AboutHeaderView: UIView {
    
    // MARK: - Views
    private let profileImageView = UIImageView()
    private let profileUserNameLabel = UILabel()
    private let organizationBackgroundView = UIView()
    private let organizationNameLabel = UILabel()
    private let organizationImageView = UIImageView()
    
    // MARK: - Initialize
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
    
    // MARK: - Methods
    func render(with props: ProfileProps.AboutHeaderViewProps) {
        profileImageView.kf.setImage(with: URL(string: props.profileImageUrl))
        organizationImageView.kf.setImage(with: URL(string: props.organizationImageUrl))
        profileUserNameLabel.text = props.fullName
        organizationNameLabel.text = props.organizationName
    }
}

// MARK: - Private Methods
private extension AboutHeaderView {
    
    func setupView() {
        
        self.do {
            $0.backgroundColor = .clear
        }
        
        profileImageView.do {
            $0.kf.indicatorType = .activity
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 75
            $0.clipsToBounds = true
        }
        
        profileUserNameLabel.do {
            $0.text = " "
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.rounded(ofSize: 18, weight: .semibold)
        }
        
        organizationBackgroundView.do {
            $0.backgroundColor = .systemGray6
            $0.roundCorners([.allCorners], radius: 10)
        }
        
        organizationNameLabel.do {
            $0.text = " "
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        organizationImageView.do {
            $0.kf.indicatorType = .activity
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func addViews() {
        
        addSubview(profileImageView)
        addSubview(profileUserNameLabel)
        addSubview(organizationBackgroundView)
        organizationBackgroundView.addSubview(organizationNameLabel)
        organizationBackgroundView.addSubview(organizationImageView)
    }
    
    func setupConstraints() {
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(150)
        }
        
        profileUserNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        organizationBackgroundView.snp.makeConstraints {
            $0.top.equalTo(profileUserNameLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        organizationNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        organizationImageView.snp.makeConstraints {
            $0.top.equalTo(organizationNameLabel.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
}
