//
//  ActualView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import Kingfisher

class ActualView: UIView {
    
    // MARK: - Views
    private let imageView = UIImageView()
    private let labelBackground = UIView()
    private let actualLabel = UILabel()
    
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
    func render(with props: MainViewControllerProps.ActualProps) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: props.imageUrl),
            options: [.cacheOriginalImage])
        actualLabel.text = props.actualTitle
    }
}

// MARK: - Private Methods
private extension ActualView {
    
    func setupView() {
        
        self.do {
            $0.backgroundColor = .clear
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }
        
        labelBackground.do {
            $0.backgroundColor = Colors.blackOpacity44.color
            $0.layer.masksToBounds = true
        }
        
        actualLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = .white
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
    }
    
    func addViews() {
        
        addSubviews([imageView])
        imageView.addSubviews([labelBackground])
        labelBackground.addSubviews([actualLabel])
    }
    
    func setupConstraints() {
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelBackground.snp.makeConstraints {
            $0.trailing.leading.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        actualLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
