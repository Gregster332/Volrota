//
//  EventView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import Kingfisher

class EventView: UIView {
    
    // MARK: - Views
    private let eventImageView = UIImageView()
    private let eventTitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let dateStackView = UIStackView()
    private let locationLabel = UILabel()
    private let locationStackView = UIStackView()
    
    // MARK: - Initialize
    init() {
        super.init(frame: .zero)
        setupView()
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with props: MainViewControllerProps.EventViewProps) {
        eventImageView.kf.setImage(with: URL(string: props.eventImageURL))
        eventTitleLabel.text = props.eventTitle
        dateLabel.text = props.datePeriod
        locationLabel.text = props.placeFullName
    }
}

// MARK: - Private Methods
private extension EventView {
    
    func setupView() {
        
        self.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .systemGray6
        }
        
        eventImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }
        
        eventTitleLabel.do {
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

        locationLabel.do {
            $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .systemGray2
        }

        let locationImage = UIImageView()
        locationImage.image = Images.locationImage.image
        locationImage.contentMode = .scaleAspectFill
        
        locationImage.snp.makeConstraints {
            $0.size.equalTo(14)
        }

        locationStackView.do {
            $0.addArrangedSubview(locationImage)
            $0.addArrangedSubview(locationLabel)
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.spacing = 8
        }
    }
    
    func addViews() {
        addSubviews(
            [
                eventImageView,
                eventTitleLabel,
                dateStackView,
                locationStackView
            ]
        )
    }
    
    func setupConstraints() {
        
        eventImageView.snp.makeConstraints {
            $0.height.equalTo(240)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        eventTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(eventImageView.snp.bottom).offset(8)
        }
        
        dateStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(eventTitleLabel.snp.bottom).offset(10)
        }

        locationStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
        }
    }
}
