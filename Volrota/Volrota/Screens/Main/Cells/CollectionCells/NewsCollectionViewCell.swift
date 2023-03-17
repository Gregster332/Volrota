//
//  NewsCollectionViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import SnapKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    private let newsView = NewsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        setupConstraints()
    }
    
    func render(with props: MainViewController.MainViewControllerProps.NewsViewProps) {
        newsView.render(props: props)
    }
}

private extension NewsCollectionViewCell {
    
    func addViews() {
        contentView.addSubviews([newsView])
    }
    
    func setupConstraints() {
        
        newsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
