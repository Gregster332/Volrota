//
//  EventCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/8/23.
//

import Kingfisher

class EventCell: UICollectionViewCell {
    
    // MARK: - Views
    private let image = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let dateStackView = UIStackView()
    private let placeLabel = UILabel()
    private let placeStackView = UIStackView()
    
    // MARK: - Initialize
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
    
    // MARK: - Methods
    func render(with props: EventsViewControllerProps.EventItem) {
        image.kf.setImage(
            with: URL(string: props.imageUrl)
        )
        titleLabel.text = props.name
        dateLabel.text = props.date
        placeLabel.text = props.place
    }
}

// MARK: - Private Methods
private extension EventCell {
    
    func setupView() {
        
        contentView.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .systemGray6
        }
        
        image.do {
            $0.contentMode = .scaleAspectFill
            $0.kf.indicatorType = .activity
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.textColor = .black
        }
        
        dateLabel.do {
            $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .black
        }
        
        let dateImage = UIImageView()
        dateImage.image = Images.dateImage.image
        dateImage.contentMode = .scaleAspectFill
        
        dateImage.snp.makeConstraints {
            $0.size.equalTo(14)
        }
        
        dateStackView.do {
            $0.addArrangedSubview(dateImage)
            $0.addArrangedSubview(dateLabel)
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.spacing = 8
        }
        
        placeLabel.do {
            $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .black
        }
        
        let locationImage = UIImageView()
        locationImage.image = Images.locationImage.image
        locationImage.contentMode = .scaleAspectFill
        locationImage.frame.size = CGSize(width: 14, height: 14)
        
        locationImage.snp.makeConstraints {
            $0.size.equalTo(14)
        }
        
        placeStackView.do {
            $0.addArrangedSubview(locationImage)
            $0.addArrangedSubview(placeLabel)
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.spacing = 8
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateStackView)
        contentView.addSubview(placeStackView)
        
        image.snp.makeConstraints {
            $0.height.equalTo(240)
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        dateStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        placeStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
        }
    }
}
