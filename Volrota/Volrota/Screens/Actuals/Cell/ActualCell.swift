//
//  ActualCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/10/23.
//

import Kingfisher

class ActualCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let textBackgroundView = UIVisualEffectView()
    private let titleLabel = UILabel()
    private let cityNameLabel = UILabel()
    
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
    
    func render(with props: ActualsViewControllerProps.ActualProps) {
        imageView.kf.setImage(with: URL(string: props.imageUrl))
        titleLabel.text = props.title
        cityNameLabel.text = props.cityName
    }
}

private extension ActualCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 16
        }
        
        imageView.do {
            $0.kf.indicatorType = .activity
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
            //$0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        textBackgroundView.do {
            $0.alpha = 0.95
            $0.effect = UIBlurEffect(style: .dark)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.textColor = .white
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }
        
        cityNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.textColor = .white
        }
    }
    
    func setupConstraints() {
        addSubview(imageView)
        addSubview(textBackgroundView)
        addSubview(titleLabel)
        addSubview(cityNameLabel)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(textBackgroundView.snp.top).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(34)
        }
        
        cityNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
