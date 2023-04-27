//
//  EventSubscriptionCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/15/23.
//

import UIKit

class EventSubscriptionCell: UICollectionViewCell {
    
    private var didTapOnSubscribe: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let subscribeButton = UIButton(type: .custom)
    
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
    
    func render(with props: EventDetailViewControllerProps.SubscribeEventSection) {
        didTapOnSubscribe = props.didTapOnSubscribe
        switch props.state {
        case .available:
            titleLabel.text = Strings.EventDetail.eventAvailable
            titleLabel.textColor = .systemGreen
            subscribeButton.backgroundColor = Colors.accentColor.color
        case .expired:
            titleLabel.text = Strings.EventDetail.eventExpired
            titleLabel.textColor = .systemRed
            subscribeButton.backgroundColor = .systemGray5
            subscribeButton.isEnabled = false
        case .subscribed:
            titleLabel.text = Strings.EventDetail.alreadySusbcribed
            titleLabel.textColor = .systemBlue
            subscribeButton.backgroundColor = .systemGray5
            subscribeButton.isEnabled = false
        }
    }
}

private extension EventSubscriptionCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        subscribeButton.do {
            $0.setTitle(Strings.EventDescription.subscribe, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 12
            $0.addTarget(self, action: #selector(handleTapOnSubscribe), for: .touchUpInside)
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subscribeButton)
        
        subscribeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(subscribeButton.snp.leading).offset(-16)
        }
    }
    
    @objc func handleTapOnSubscribe() {
        didTapOnSubscribe?()
    }
}
