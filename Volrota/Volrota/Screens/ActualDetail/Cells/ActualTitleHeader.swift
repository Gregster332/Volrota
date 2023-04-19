//
//  ActualTitleHeader.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/12/23.
//

import UIKit

class ActualTitleHeader: UIView {
    
    private let titleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func render(with title: String) {
        titleLabel.text = title
    }
}

private extension ActualTitleHeader {
    
    func setupView() {
        
        self.do {
            $0.backgroundColor = .clear
        }
        
        titleLabel.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }
    }
    
    func setupConstraints() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }
    }
}
