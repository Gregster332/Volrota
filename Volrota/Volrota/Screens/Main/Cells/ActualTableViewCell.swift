//
//  ActualTableViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import UIKit

class ActualTableViewCell: UITableViewCell {
    
    private let actualView = ActualView()
    
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
    
    func render(with props: MainViewController.MainViewControllerProps.ActualProps) {
        actualView.render(with: props)
    }
}

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
