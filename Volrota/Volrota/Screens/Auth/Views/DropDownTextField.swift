//
//  DropDownTextField.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/26/23.
//

import DropDown

struct DropDownTextFieldProps {
    let items: [String]
    let chooseOrganizationCompletion: ((Int) -> Void)?
}

class DropDownTextField: UIView {
    
    private var chooseOrganizationCompletion: ((Int) -> Void)?
    
    // MARK: - Views
    private let textField = UITextField()
    private let dropDown = DropDown()
    private let dropDownMenuButton = UIButton()
    
    // MARK: - Initialize
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
    
    // MARK: - Methods
    func render(with props: DropDownTextFieldProps) {
        dropDown.dataSource = props.items
        chooseOrganizationCompletion = props.chooseOrganizationCompletion
    }
}

private extension DropDownTextField {
    
    func setupView() {
        
        self.do {
            $0.backgroundColor = .clear
        }
        
        dropDownMenuButton.do {
            $0.setImage(UIImage(systemName: "chevron.down.circle.fill")!, for: .normal)
            $0.addTarget(
                self,
                action: #selector(handleOpenDropDown),
                for: .touchUpInside
            )
        }
        
        textField.do {
            $0.textColor = .black
            $0.backgroundColor = .systemGray6
//            $0.layer.borderWidth = 1
//            $0.layer.borderColor = UIColor.systemBlue.cgColor
            $0.layer.cornerRadius = 10
            $0.placeholder = "Организация"
            $0.setLeftPaddingPoints(12)
            $0.isEnabled = false
        }
        
        dropDown.do {
            $0.anchorView = textField
            $0.selectionAction = { [weak self] index, item in
                self?.textField.text = item
                self?.chooseOrganizationCompletion?(index)
            }
            $0.dismissMode = .onTap
            $0.direction = .bottom
            $0.bottomOffset = CGPoint(x: 0, y: 48)
            $0.dimmedBackgroundColor = .clear
            $0.backgroundColor = .white
            $0.selectionBackgroundColor = .clear
            $0.cornerRadius = 12
        }
    }
    
    func setupConstraints() {
        addSubview(textField)
        addSubview(dropDownMenuButton)
        
        dropDownMenuButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(20)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(dropDownMenuButton.snp.leading).offset(-8)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - UI Actions
    @objc func handleOpenDropDown() {
        dropDown.show()
    }
}
