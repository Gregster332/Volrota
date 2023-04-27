//
//  EventDescriptionCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/14/23.
//

import UIKit

class EventDescriptionCell: UICollectionViewCell {
    
    private let descriptionLabel = UILabel()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    
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
    
    func render(with props: EventDetailViewControllerProps.DescriptionSection) {
        descriptionLabel.text = props.descriptionText
        startDateLabel.text = Strings.EventDescription.startAt + props.startDate
        endDateLabel.text = Strings.EventDescription.endAt + props.endDate
    }
}

private extension EventDescriptionCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        descriptionLabel.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        startDateLabel.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        endDateLabel.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(startDateLabel)
        contentView.addSubview(endDateLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        startDateLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(startDateLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
