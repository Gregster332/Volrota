//
//  AddEventDateCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/25/23.
//

import UIKit

class AddEventDateCell: UICollectionViewCell {
    
    var didChangeDate: ((Date) -> Void)?
    
    private let startDateLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let startDateStackView = UIStackView()
    
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
    
    func configure(with title: String, date: Date) {
        startDateLabel.text = title
        startDatePicker.date = date
    }
}

private extension AddEventDateCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 12
        }
        
        startDateLabel.do {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
        }
        
        startDatePicker.do {
            $0.preferredDatePickerStyle = .compact
            $0.addTarget(self, action: #selector(handleDateChange), for: .valueChanged)
        }
        
        startDateStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .fillProportionally
        }
    }
    
    func setupConstraints() {
        startDateStackView.addArrangedSubview(startDateLabel)
        startDateStackView.addArrangedSubview(startDatePicker)
        contentView.addSubview(startDateStackView)
        
        startDateStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func handleDateChange() {
        didChangeDate?(startDatePicker.date)
    }
}
