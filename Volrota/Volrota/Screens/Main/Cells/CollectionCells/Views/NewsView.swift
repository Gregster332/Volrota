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
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        banner.do {
            $0.layer.cornerRadius = 12
        }
        
        bannerTitle.do {
            $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            $0.textAlignment = .center
        }
    }
    
    func addViews() {
        
        view.addSubviews([titleLabel, banner])
        banner.addSubviews([bannerTitle])
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview().inset(10)
        }
        
        banner.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }
        
        bannerTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func applyProps(props: MainViewController.MainViewControllerProps.NewsViewProps) {
        titleLabel.text = props.title
        titleLabel.textColor = props.titleColor
        backgroundColor = props.viewBackgroundColor
        banner.backgroundColor = props.bannerBackgroundColor
        bannerTitle.text = props.bannerTitle
        bannerTitle.textColor = props.bannerTitleColor
        bannerTitle.sizeToFit()
    }
}
