//
//  NewsCollectionViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import SnapKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    private let newsView = NewsView()
    
    // MARK: - Initialize
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
    
    // MARK: - Methods
    func render(with props: MainViewControllerProps.NewsViewProps) {
        newsView.render(props: props)
    }
}

// MARK: - Private Methods
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
