//
//  EventCollectionViewCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    private let eventView = EventView()
    
    // MARK: - Initialize
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
    
    // MARK: - Methods
    func render(with props: MainViewControllerProps.EventViewProps) {
        eventView.render(with: props)
    }
}

// MARK: - Private Methods
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
