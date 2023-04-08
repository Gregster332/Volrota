//
//  LoadingView.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - Views
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    
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
}

// MARK: - Private Methods
private extension LoadingView {
    
    func setupView() {
        
        spinner.do {
            $0.style = .large
            $0.startAnimating()
        }
        
        loadingLabel.do {
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.text = "Идет загрузка. Пожалуйста, подождите"
        }
    }
    
    func addViews() {
        
        addSubviews([spinner, loadingLabel])
    }
    
    func setupConstraints() {
        
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.top.equalTo(spinner.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
