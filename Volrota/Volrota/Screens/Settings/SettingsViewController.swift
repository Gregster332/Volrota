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
        
        let cells: [SettingsCells]
        
        enum SettingsCells {
            case profileCell(ProfileCellProps)
            case defaultCell(SettingsCellProps)
        }
        
        struct SettingsCellProps {
            let title: String
            let isToggled: Bool
            let initialValue: Bool
            let toggleAction: (() -> Void)?
        }
        
        struct ProfileCellProps {
            let avatarImage: UIImage
            let userName: String
            let action: (() -> Void)?
        }
    }
    
    // MARK: - Properties
    var presenter: SettingsPresenterProtocol!
    private var cells: [SettingsViewController.SettingsProps.SettingsCells] = []
    
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
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    
    func setupView() {
        view.do {
            $0.backgroundColor = .white
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.separatorStyle = .singleLine
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: SettingsTableViewCell.self)
            $0.register(cellWithClass: ProfileSettingsCell.self)
        }
    }
    
    func addViews() {
        
        view.addSubviews([tableView])
    }
    
    func setupConstraints() {
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
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
        if case .profileCell(let profileCellProps) = props {
            let cell = tableView.dequeueCell(withClass: ProfileSettingsCell.self, for: indexPath) as ProfileSettingsCell
            cell.render(with: profileCellProps)
        } else if case .defaultCell(let settingsCellProps) = props {
            let cell = tableView.dequeueCell(withClass: SettingsTableViewCell.self, for: indexPath) as SettingsTableViewCell
            cell.render(with: settingsCellProps)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let props = cells[indexPath.row]
        switch props {
        case .profileCell:
            return 80
        case .defaultCell:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let props = cells[indexPath.row]
        switch props {
        case .profileCell(let profileCellProps):
            profileCellProps.action?()
        case .defaultCell:
            return
        }
    }
}
