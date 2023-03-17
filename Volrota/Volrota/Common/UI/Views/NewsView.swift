//
//  NewsView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import SnapKit

class NewsView: UIView {
    
    private let titleLabel = UILabel()
    private let banner = UIView()
    private let bannerTitle = UILabel()
    
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
    
    func render(props: MainViewController.MainViewControllerProps.NewsViewProps) {
        applyProps(props: props)
    }
}

private extension NewsView {
    
    func setupView() {
        
        self.do {
            $0.layer.cornerRadius = 16
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        banner.do {
            $0.layer.cornerRadius = 12
        }
        
        bannerTitle.do {
            $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            $0.textAlignment = .center
        }
    }
    
    func addViews() {
        
        view.addSubviews([titleLabel, banner])
        banner.addSubviews([bannerTitle])
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
        }
        
//        banner.snp.makeConstraints {
//            $0.trailing.equalTo(titleLabel)
//            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
//            $0.width.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
//        }
    }
    
    func applyProps(props: MainViewController.MainViewControllerProps.NewsViewProps) {
        titleLabel.text = props.title
        titleLabel.textColor = props.titleColor
        backgroundColor = props.viewBackgroundColor
    }
}
