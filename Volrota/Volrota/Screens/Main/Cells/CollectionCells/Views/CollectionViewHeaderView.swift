//
//  TableViewHeaderView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

class CollectionViewHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    private var watchingAllCompletion: (() -> Void)?
    
    // MARK: - Views
    private let headerLabel = UILabel()
    private let watchingAllButton = UIButton()
    
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
    func render(with props: MainViewControllerProps.HeaderProps) {
        watchingAllCompletion = props.watchingAllCompletion
        headerLabel.text = props.headerTitle
    }
}

// MARK: - Private Methods
private extension CollectionViewHeaderView {
    
    func setupView() {
        
        self.do {
            $0.backgroundColor = .white
            $0.roundCorners([.bottomLeft, .bottomRight], radius: 16)
        }
        
        headerLabel.do {
            $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            $0.textAlignment = .left
            $0.textColor = .black
        }
        
        watchingAllButton.do {
            $0.setTitle(Strings.Main.seeAll, for: .normal)
            $0.setTitleColor(Colors.purpleColor.color, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.addTarget(self, action: #selector(handleTapOnWatchingAll), for: .touchUpInside)
        }
    }
    
    func addViews() {
        
        addSubviews([headerLabel, watchingAllButton])
    }
    
    func setupConstraints() {
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        watchingAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - UI Actions
    @objc func handleTapOnWatchingAll() {
        watchingAllCompletion?()
    }
}
