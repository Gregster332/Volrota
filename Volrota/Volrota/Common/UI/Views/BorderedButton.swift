//
//  File.swift
//  
//
//  Created by Greg Zenkov on 2/6/23.
//

import UIKit

struct BorderedButtonProps {
    let text: String
    var backgroundColor: UIColor?
    var font: BorderedButtonFontProps?
    var actionCompletion: (() -> Void)?
    var isLoading: Bool?
    
    struct BorderedButtonFontProps {
        let fontSize: CGFloat
        let fontWeight: UIFont.Weight
        let lineHeight: CGFloat
        let textColor: UIColor
    }
    
    enum ActionType {
        case just(())
        case signIn((String, String) -> Void)
    }
}

class BorderedButton: UIView {
    
    // MARK: - Properties
    private var actionCompletion: (() -> Void)?
    
    // MARK: - Views
    private let buttonLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let actionButton = UIButton(type: .system)
    
    // MARK: - Initialize
    init() {
        super.init(frame: .zero)
        setupView()
        addViews()
        setupConstraints()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with props: BorderedButtonProps?) {
        self.actionCompletion = props?.actionCompletion
        self.backgroundColor = props?.backgroundColor ?? Colors.accentColor.color
        self.buttonLabel.font = UIFont.rounded(
            ofSize: props?.font?.fontSize ?? 22,
            weight: props?.font?.fontWeight ?? .semibold,
            lineHeight: props?.font?.lineHeight ?? 32.87
        )
        self.buttonLabel.text = props?.text
        self.buttonLabel.textColor = props?.font?.textColor ?? .white
        if let isLoading = props?.isLoading, isLoading {
            showSpinner()
        } else {
            hideSpinner()
        }
        
    }
    
    func addTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        actionButton.addTarget(target, action: action, for: event)
    }
}

// MARK: - Private Methods
private extension BorderedButton {
    
    func setupView() {
        
        self.do {
            $0.layer.cornerRadius = 12
        }
        
        buttonLabel.do {
            $0.textAlignment = .center
        }
        
        spinner.do {
            $0.isHidden = true
            $0.color = .white
        }
        
        actionButton.do {
            $0.backgroundColor = .clear
            $0.addTarget(
                self,
                action: #selector(handleActionButton),
                for: .touchUpInside
            )
        }
    }
    
    func addViews() {
        
        addSubview(buttonLabel)
        addSubview(spinner)
        addSubview(actionButton)
    }
    
    func setupConstraints() {
        
        buttonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showSpinner() {
        actionButton.isEnabled = false
        spinner.isHidden = false
        buttonLabel.isHidden = true
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        actionButton.isEnabled = true
        spinner.isHidden = true
        buttonLabel.isHidden = false
        spinner.stopAnimating()
    }
    
    // MARK: - UIActions
    @objc func handleActionButton() {
        actionCompletion?()
    }
}
