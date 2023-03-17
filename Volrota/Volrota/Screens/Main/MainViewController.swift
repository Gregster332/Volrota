// 
//  MainViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func render(with props: MainViewController.MainViewControllerProps)
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    struct MainViewControllerProps {
        let profileViewTitle: String
        let sections: [Section]
        let mainViewControllerState: MainViewControllerState
        let profileTapCompletion: (() -> Void)?
        
        enum Section {
            case news([NewsViewProps]?)
            case events([EventViewProps]?)
            case actual([ActualProps]?)
            case header([HeaderProps]?)
        }
        
        enum MainViewControllerState {
            case loading
            case error
            case success
        }
        
        struct NewsViewProps {
            let title: String
            let bannerTitle: String
            let viewBackgroundColor: UIColor
            let bannerBackgroundColor: UIColor
            let titleColor: UIColor
            let bannerTitleColor: UIColor
        }
        
        struct EventViewProps {
            let eventTitle: String
            let eventImage: UIImage
            let date: String
            let location: String
        }
        
        struct ActualProps {
            let image: UIImage
            let actualTitle: String
        }
        
        struct HeaderProps {
            let headerTitle: String
            let isLocationView: Bool
            let watchingAllCompletion: (() -> Void)?
        }
    }
    
    // MARK: - Properties
    
    //var presenter: MainPresenterProtocol!
    private var sections: [MainViewControllerProps.Section] = []
    private var profileTapCompletion: (() -> Void)?
    
    // MARK: - Views
    
    private let profileView = ProfileView()
    private let tableView = UITableView()
    private let errorView = ErrorView()
    private let loadingView = LoadingView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    
    func render(with props: MainViewControllerProps) {
        applyProps(props: props)
    }
}

// MARK: - Private Methods
private extension MainViewController {
    
    func setupView() {
        
        self.do {
            $0.setupNavigationBar(with: profileView)
            $0.view.backgroundColor = .white
        }
        
        profileView.do {
            $0.addTarget(self, action: #selector(handleTapOnProfileView), for: .touchUpInside)
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.register(cellWithClass: HorizontalTableViewCell.self)
            $0.register(cellWithClass: ActualTableViewCell.self)
            $0.showsVerticalScrollIndicator = false
        }
        
        errorView.do {
            $0.isHidden = true
        }
        
        loadingView.do {
            $0.isHidden = false
        }
    }
    
    func addViews() {
        view.addSubviews([tableView, errorView, loadingView])
    }
    
    func setupConstraints() {
        
        profileView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(39)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func applyProps(props: MainViewControllerProps) {
        profileView.setNavTitle(props.profileViewTitle)
        sections = props.sections
        profileTapCompletion = props.profileTapCompletion
        
        let state = props.mainViewControllerState
        tableView.animated(hide: state != .success)
        errorView.animated(hide: state != .error)
        loadingView.animated(hide: state != .loading)
        if !tableView.isHidden {
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Actions
    
    @objc func handleTapOnProfileView() {
        profileTapCompletion?()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count - 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = sections[section]
        
        if case .actual(let actuals) = item, let actuals = actuals {
            return actuals.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = sections[indexPath.section]
        
        if case .actual(let actuals) = item, let actuals = actuals {
            let cell = tableView.dequeueCell(withClass: ActualTableViewCell.self, for: indexPath) as ActualTableViewCell
            cell.render(with: actuals[indexPath.row])
        } else {
            let cell = tableView.dequeueCell(withClass: HorizontalTableViewCell.self, for: indexPath) as HorizontalTableViewCell
            cell.render(with: item)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section]
        
        if case .news = item {
            return 120
        } else if case .events = item {
            return 365
        } else {
            return 347
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = sections.filter {
            if case .header = $0 {
                return true
            } else {
                return false
            }
        }.first!
        
        switch item {
        case .header(let headers):
            let headerView = TableViewHeaderView()
            if let current = headers?[section] {
                headerView.render(with: current)
            }
            return headerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 35
        default:
            return 55
        }
    }
}
