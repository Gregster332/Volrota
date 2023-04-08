// 
//  ProfileViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import Kingfisher
import Lottie

struct ProfileProps {
    let isLoading: Bool
    var profileSettingsCells: [ProfileSettingsCell]?
    var aboutHeaderViewProps: AboutHeaderViewProps?
    
    struct ProfileSettingsCell {
        let title: String
        let textColor: UIColor
        let action: (() -> Void)?
    }
    
    struct AboutHeaderViewProps {
        let profileImageUrl: String
        let fullName: String
        let organizationName: String
        let organizationImageUrl: String
    }
}

protocol ProfileViewControllerProtocol: AnyObject {
    func render(with props: ProfileProps)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ProfilePresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var profileSettingsCells: [ProfileProps.ProfileSettingsCell] = []
    
    // MARK: - Views
    private let aboutHeaderView = AboutHeaderView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let loadingView = LoadingView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
        presenter.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Methods
    func render(with props: ProfileProps) {
        
        if props.isLoading {
            loadingView.layer.opacity = 1
            tableView.layer.opacity = 0
        } else {
            loadingView.layer.opacity = 0
            tableView.layer.opacity = 1
            profileSettingsCells = props.profileSettingsCells ?? []
            if let headerProps = props.aboutHeaderViewProps {
                aboutHeaderView.render(with: headerProps)
            }
            tableView.reloadData()
        }
    }
}

// MARK: - Private Methods
private extension ProfileViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.separatorStyle = .singleLine
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: ProfileTableViewCell.self)
        }
    }
    
    func addViews() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
    }
    
    func setupConstraints() {

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileSettingsCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(withClass: ProfileTableViewCell.self, for: indexPath) as ProfileTableViewCell
        let item = profileSettingsCells[indexPath.row]
        cell.render(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = profileSettingsCells[indexPath.row]
        item.action?()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return aboutHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 376
    }
}
