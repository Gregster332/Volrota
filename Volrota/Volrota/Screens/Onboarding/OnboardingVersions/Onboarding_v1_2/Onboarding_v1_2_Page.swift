//
//  Onboarding_v1_2_Page.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/14/23.
//

import UIKit

class Onboarding_v1_2_Page: UIViewController {
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    init(model: Onboarding_v1_2_Model) {
        super.init(nibName: nil, bundle: nil)
        configureViews(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

private extension Onboarding_v1_2_Page {
    
    func configureViews(model: Onboarding_v1_2_Model) {
        titleLabel.text = model.titleText
        imageView.image = model.image
        descriptionLabel.text = model.descriptionText
    }
    
    func setupView() {
        view.do {
            $0.backgroundColor = .white
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .black
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .systemGray4
        }
    }
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
