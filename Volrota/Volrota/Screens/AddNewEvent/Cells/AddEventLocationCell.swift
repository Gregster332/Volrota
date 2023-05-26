//
//  AddEventLocationCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/26/23.
//

import UIKit

protocol AddEventLocationCellProtocol: AnyObject {
    func didTapOnChangeLocation()
}

class AddEventLocationCell: UICollectionViewCell {
    
    private weak var delegate: AddEventLocationCellProtocol?
    
    private let locationNameLabel = UILabel()
    private let chooseLocationButton = UIButton(type: .custom)
    
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
    
    func configure(with delegate: AddEventLocationCellProtocol, placeName: String) {
        self.delegate = delegate
        self.locationNameLabel.text = placeName
    }
}

private extension AddEventLocationCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        locationNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.textAlignment = .left
        }
        
        chooseLocationButton.do {
            $0.setTitle(Strings.AddNewEvent.chooseLocation, for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(
                self,
                action: #selector(handleTapOnChooseLocationButton),
                for: .touchUpInside
            )
            $0.backgroundColor = Colors.lightGrey.color
            $0.layer.cornerRadius = 12
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(locationNameLabel)
        contentView.addSubview(chooseLocationButton)
        
        chooseLocationButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        locationNameLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(4)
            $0.bottom.equalTo(chooseLocationButton.snp.top).offset(-8)
        }
    }
    
    @objc func handleTapOnChooseLocationButton() {
        delegate?.didTapOnChangeLocation()
    }
}
