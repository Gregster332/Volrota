//
//  ErrorView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

class ErrorView: UIView {
    
    private let errorImage = UIImageView()
    private let errorLabel = UILabel()
    
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
}

private extension ErrorView {
    
    func setupView() {
        
        errorImage.do {
            $0.contentMode = .scaleAspectFill
            $0.image = Images.errorImge.image
        }
        
        errorLabel.do {
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.text = "Упс, не удалось загрузить контент. Попробуйте обновить страницу"
        }
    }
    
    func addViews() {
        
        addSubviews([errorImage, errorLabel])
    }
    
    func setupConstraints() {
        
        errorImage.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(errorImage.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
