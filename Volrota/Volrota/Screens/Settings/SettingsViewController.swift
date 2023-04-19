// 
//  SettingsViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

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
        let avatarImageUrl: String
        let userFullName: String
        let action: (() -> Void)?
    }
}

protocol SettingsViewControllerProtocol: AnyObject {
    func render(with props: SettingsProps)
}

final class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    // MARK: - Properties
    var initialCompletion: (() -> Void)?
    var viewWillDisappearCompletion: (() -> Void)?
    private var cells: [SettingsProps.SettingsCells] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialCompletion?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearCompletion?()
    }
    
    // MARK: - Methods
    func render(with props: SettingsProps) {
        cells = props.cells
        tableView.reloadData()
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
            $0.separatorStyle = .none
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
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cells.count - (cells.count - 1)
        } else {
            return cells.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .profileCell(let profileCellProps) = cells[indexPath.row], indexPath.section == 0 {
            let cell = tableView.dequeueCell(withClass: ProfileSettingsCell.self, for: indexPath) as ProfileSettingsCell
            cell.render(with: profileCellProps)
        } else if case .defaultCell(let settingsCellProps) = cells[indexPath.row + 1] {
            let cell = tableView.dequeueCell(withClass: SettingsTableViewCell.self, for: indexPath) as SettingsTableViewCell
            cell.render(with: settingsCellProps)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 85
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Strings.Settings.profile
        } else {
            return Strings.Settings.appSettings
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .profileCell(let profileCellProps) = cells[indexPath.row], indexPath.section == 0 {
            profileCellProps.action?()
        } else if case .defaultCell = cells[indexPath.row + 1] {
            return
        }
    }
}
