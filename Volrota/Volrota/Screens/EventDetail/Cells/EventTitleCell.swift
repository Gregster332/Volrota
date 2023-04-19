//
//  EventTitleCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/14/23.
//

import Kingfisher

class EventTitleCell: UICollectionViewCell {
    
    private let eventImageView = UIImageView()
    private let eventTitleLabel = UILabel()
    
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
    
    func render(with props: EventDetailViewControllerProps.ImageTitleSection) {
        eventTitleLabel.text = props.titleText
        eventImageView.kf.setImage(with: URL(string: props.imageUrl))
    }
}

private extension EventTitleCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.layer.masksToBounds = true
        }
        
        eventImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.kf.indicatorType = .activity
            $0.roundCorners([.bottomLeft, .bottomRight], radius: 14)
        }
        
        eventTitleLabel.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.textAlignment = .left
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(eventImageView)
        contentView.addSubview(eventTitleLabel)
        
        eventImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(220)
        }
        
        eventTitleLabel.snp.makeConstraints {
            $0.top.equalTo(eventImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
