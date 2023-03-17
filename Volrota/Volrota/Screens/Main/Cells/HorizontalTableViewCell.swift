//
//  NewsTableViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import UIKit

class HorizontalTableViewCell: UITableViewCell {
    
    private var section: MainViewController.MainViewControllerProps.Section = .news(nil)
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
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
    
    func render(with props: MainViewController.MainViewControllerProps.Section) {
        section = props
    }
}

private extension HorizontalTableViewCell {
    
    func setupView(){
        
        self.do {
            $0.selectionStyle = .none
            $0.backgroundColor = .clear
        }
        
        collectionViewFlowLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 12
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.register(cellWithClass: NewsCollectionViewCell.self)
            $0.register(cellWithClass: EventCollectionViewCell.self)
        }
    }
    
    func addViews() {
        contentView.addSubviews([collectionView])
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}

extension HorizontalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.section {
        case let .news(news):
            if let news = news {
                return news.count
            }
        case .events(let events):
            if let events = events {
                return events.count
            }
        case .actual(let actual):
            if let actual = actual {
                return actual.count
            }
        case .header(let headers):
            if let headers = headers {
                return headers.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case let .news(news) = self.section, let news = news {
            let cell = collectionView.dequeueCell(with: indexPath) as NewsCollectionViewCell
            cell.render(with: news[indexPath.item])
            return cell
        } else if case let .events(events) = self.section, let events = events {
            let cell = collectionView.dequeueCell(with: indexPath) as EventCollectionViewCell
            cell.render(with: events[indexPath.item])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension HorizontalTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if case .news = self.section {
            return CGSize(width: 300, height: 80)
        } else if case .events = self.section {
            return CGSize(width: 334, height: 355)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}
