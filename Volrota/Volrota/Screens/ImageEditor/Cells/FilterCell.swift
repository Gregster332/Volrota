//
//  FilterCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/16/23.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = Colors.accentColor.color
            } else {
                contentView.backgroundColor = .systemGray6
            }
        }
    }
    
    private let textLabel = UILabel()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
    
    func configure(with filter: String) {
        textLabel.text = filter
        textLabel.sizeToFit()
    }
}

private extension FilterCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 12
        }
        
        textLabel.do {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
