//
//  UserCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/3/23.
//

import SnapKit
import Utils

class UserCell: UICollectionViewCell {
    
    private var changeNameAction: (() -> Void)?
    private var changeUserImageAction: (() -> Void)?
    private var didEndEditingAction: ((String) -> Void)?
    
    // MARK: - Views
    private let profileImageView = UIImageView()
    private let profileNameTextField = UITextField()
    private let actionButton = UIButton()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    func render(with props: ProfileViewControllerProps.UserCellProps, isEditingMode: Bool) {
        profileImageView.kf.setImage(with: URL(string: props.profileImageUrl))
        profileNameTextField.text = props.fullName
        profileNameTextField.isEnabled = isEditingMode
        profileNameTextField.backgroundColor = isEditingMode ? .white : .clear
        changeNameAction = props.changeUserNameAction
        changeUserImageAction = props.changeUserImageAction
        didEndEditingAction = props.didEndEditingAction
    }
}

// MARK: - Private Methods
private extension UserCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 14
        }
        
        profileImageView.do {
            //$0.kf.indicatorType = .activity
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 75
            $0.clipsToBounds = true
        }
        
        actionButton.do {
            $0.backgroundColor = .clear
            
            let changeName = UIAction(title: "Изменить полное имя") { _ in
                self.changeNameAction?()
            }
            
            let changeImage = UIAction(title: "Изменить аватар") { _ in
                self.changeUserImageAction?()
            }
            
            let menu = UIMenu(title: "Редактирование", children: [changeName, changeImage])
            
            $0.menu = menu
            $0.showsMenuAsPrimaryAction = true
        }
        
        profileNameTextField.do {
            $0.delegate = self
            $0.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.rounded(ofSize: 18, weight: .semibold)
            $0.layer.cornerRadius = 14
            $0.clearButtonMode = .whileEditing
        }
    }
    
    func addViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(actionButton)
        contentView.addSubview(profileNameTextField)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(150)
        }
        
        actionButton.snp.makeConstraints {
            $0.edges.equalTo(profileImageView)
        }
        
        profileNameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    @objc func didEndEditing() {
        if let text = self.profileNameTextField.text, !text.isEmpty {
            didEndEditingAction?(text)
        }
    }
}

extension UserCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            return true
        } else {
            return false
        }
    }
}
