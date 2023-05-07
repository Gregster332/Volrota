//
//  EventsSectionHeader.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/18/23.
//

import UIKit

class EventsSectionHeader: UICollectionReusableView {
    
    // MARK: - Views
    private let titleLabel = UILabel()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    func configure(title: String?) {
        titleLabel.text = title ?? ""
    }
}

// MARK: - Private Methods
private extension EventsSectionHeader {
    
    func setupView() {
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .black
        }
    }
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
