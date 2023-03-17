// 
//  SettingsViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

protocol SettingsViewControllerProtocol: AnyObject {
    func render(with props: SettingsViewController.SettingsProps)
}

final class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    struct SettingsProps {
        let cells: [SettingsCellProps]
        
        struct SettingsCellProps {
            let title: String
            let isToggled: Bool
            let initialValue: Bool
            let toggleAction: ((Bool) -> Void)?
        }
    }
    
    // MARK: - Properties
    var presenter: SettingsPresenterProtocol!
    private var cells: [SettingsViewController.SettingsProps.SettingsCellProps] = []
    
    // MARK: - Views
    private let avatarImageButton = UIButton()
    private let userNameLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    
    func render(with props: SettingsViewController.SettingsProps) {
        cells = props.cells
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    
    func setupView() {
        view.do {
            $0.backgroundColor = .white
        }
        
        avatarImageButton.do {
            $0.setImage(Images.profileMockLogo.image, for: .normal)
            $0.layer.cornerRadius = 50
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
        }
        
        userNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.text = "Дед"
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.separatorStyle = .singleLine
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: SettingsTableViewCell.self)
        }
    }
    
    func addViews() {
        
        view.addSubviews([avatarImageButton, userNameLabel, tableView])
    }
    
    func setupConstraints() {
        
        avatarImageButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UI Actions
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let props = cells[indexPath.row]
        let cell = tableView.dequeueCell(withClass: SettingsTableViewCell.self, for: indexPath) as SettingsTableViewCell
        cell.render(with: props)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
