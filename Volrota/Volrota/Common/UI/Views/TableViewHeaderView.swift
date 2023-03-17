//
//  TableViewHeaderView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

class TableViewHeaderView: UIView {
    
    private var watchingAllCompletion: (() -> Void)?
    
    private let headerLabel = UILabel()
    private let watchingAllButton = UIButton()
    
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
    
    func render(with props: MainViewController.MainViewControllerProps.HeaderProps) {
        watchingAllCompletion = props.watchingAllCompletion
        headerLabel.text = props.headerTitle
        if props.isLocationView {
            headerLabel.textColor = Colors.purpleColor.color
            headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            watchingAllButton.isHidden = true
        } else {
            headerLabel.textColor = .black
            watchingAllButton.isHidden = false
        }
    }
}

private extension TableViewHeaderView {
    
    func setupView() {
        
        self.do {
            $0.backgroundColor = .white
            $0.roundCorners([.bottomLeft, .bottomRight], radius: 16)
        }
        
        headerLabel.do {
            $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            $0.textAlignment = .left
        }
        
        watchingAllButton.do {
            $0.setTitle("См. все", for: .normal)
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
            $0.verticalEdges.leading.equalToSuperview().inset(8)
        }
        
        watchingAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func handleTapOnWatchingAll() {
        watchingAllCompletion?()
    }
}
