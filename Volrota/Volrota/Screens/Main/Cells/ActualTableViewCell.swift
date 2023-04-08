//
//  ActualTableViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import UIKit

class ActualTableViewCell: UITableViewCell {
    
    // MARK: - Views
    private let actualView = ActualView()
    
    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with props: MainViewControllerProps.ActualProps) {
        actualView.render(with: props)
    }
}

// MARK: - Private Methods
private extension ActualTableViewCell {
    
    func setupViews() {
        
        selectionStyle = .none
        
        contentView.do {
            $0.backgroundColor = .clear
        }
    }
    
    func addViews() {
        contentView.addSubviews([actualView])
    }
    
    func setupConstraints() {
        actualView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
