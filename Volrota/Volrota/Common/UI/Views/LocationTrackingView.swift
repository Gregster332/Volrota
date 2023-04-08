//
//  LocationTrackingView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/21/23.
//

import UIKit

class LocationTrackingView: UIView {
    
    // MARK: - Properties
    private var tapCompletion: (() -> Void)?
    
    // MARK: - Views
    private let locationNameLabel = UILabel()
    private let goToSettingsButton = UIButton()
    
    // MARK: - Initialize
    init() {
        super.init(frame: .zero)
        setupView()
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addViews()
        addConstraints()
    }
    
    // MARK: - Methods
    func render(with props: MainViewControllerProps.LocationViewProps) {
        locationNameLabel.text = props.locationName
        tapCompletion = props.locationViewTapCompletion
    }
}

// MARK: - Private Methods
private extension LocationTrackingView {
    
    func setupView() {
        
        locationNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.textColor = Colors.purpleColor.color
            $0.textAlignment = .left
        }
        
        goToSettingsButton.do {
            $0.setTitle("Настроить", for: .normal)
            $0.setTitleColor(Colors.purpleColor.color, for: .normal)
            $0.addTarget(self, action: #selector(handleGoToSettingButton), for: .touchUpInside)
        }
    }
    
    func addViews() {
        
        addSubviews([locationNameLabel, goToSettingsButton])
    }
    
    func addConstraints() {
        
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        goToSettingsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - UI Actions
    @objc func handleGoToSettingButton() {
        tapCompletion?()
    }
}
