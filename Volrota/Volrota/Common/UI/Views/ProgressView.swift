//
//  ProgressView.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/25/23.
//

import UIKit

struct ProgressViewProps {
    let propgress: Float
    let message: String
}

class ProgressView: UIView {
    
    private let blurEffectView = UIVisualEffectView()
    private let popupBackgroundView = UIView()
    private let messageLabel = UILabel()
    private let progressIndicator = UIProgressView(progressViewStyle: .default)
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func render(with props: ProgressViewProps) {
       // UIView.animate(withDuration: 0.2, delay: 0) {
            self.messageLabel.text = props.message
        self.progressIndicator.setProgress(props.propgress, animated: true)
        //}
    }
}

private extension ProgressView {
    
    func setupView() {
        blurEffectView.do {
            $0.effect = UIBlurEffect(style: .dark)
            $0.alpha = 0.9
        }
        
        popupBackgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
        }
        
        messageLabel.do {
            $0.font = UIFont.rounded(ofSize: 16, weight: .medium)
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.textColor = .black
        }
        
        progressIndicator.do {
            $0.progressTintColor = Colors.accentColor.color
            $0.trackTintColor = .systemGray6
            $0.progress = 0
        }
    }
    
    func setupConstraints() {
        addSubviews(
            [
                blurEffectView,
                popupBackgroundView,
                messageLabel,
                progressIndicator
            ]
        )
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popupBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(290)
            $0.height.equalTo(110)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(popupBackgroundView).inset(16)
        }
        
        progressIndicator.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(popupBackgroundView).inset(16)
        }
    }
}
