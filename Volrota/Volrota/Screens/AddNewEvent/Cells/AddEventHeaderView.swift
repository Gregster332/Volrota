//
//  AddEventHeaderView.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/25/23.
//

import UIKit

class AddEventHeaderView: UICollectionReusableView {
    
    // MARK: - Views
    private let headerLabel = UILabel()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with title: String) {
        headerLabel.text = title
    }
}

// MARK: - Private Methods
private extension AddEventHeaderView {
    
    func setupView() {
        
        self.do {
            $0.backgroundColor = .clear
        }
        
        headerLabel.do {
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textAlignment = .left
            $0.textColor = .black
        }
    }
    
    func setupConstraints() {
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(4)
        }
    }
}
