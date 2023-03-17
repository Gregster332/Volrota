//
//  EventCollectionViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    private let eventView = EventView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        setupConstraints()
    }
    
    func render(with props: MainViewController.MainViewControllerProps.EventViewProps) {
        eventView.render(with: props)
    }
}

private extension EventCollectionViewCell {
    
    func addViews() {
        contentView.addSubviews([eventView])
    }
    
    func setupConstraints() {
        eventView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
}
