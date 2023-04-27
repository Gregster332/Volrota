//
//  FilteringCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/18/23.
//

import UIKit

class FilteringCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        willSet {
            contentView.backgroundColor = newValue ? Colors.accentColor.color : UIColor.systemGray6
            titleLabel.textColor = newValue ? .white : .black
        }
    }
    
    private let titleLabel = UILabel()
    
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
    
    func render(with title: String) {
        titleLabel.text = title
    }
}

private extension FilteringCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = UIColor.systemGray6
            $0.layer.cornerRadius = 8
        }
        
        titleLabel.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            $0.textAlignment = .center
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
