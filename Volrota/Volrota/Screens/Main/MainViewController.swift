// 
//  MainViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit
import FirebaseFirestore

struct MainViewControllerProps {
    let sections: [Section]
    let locationViewProps: LocationViewProps?
    let mainViewControllerState: MainViewControllerState
    let profileViewProps: ProfileViewProps?
    let actualTapCompletion: ((ActualProps) -> Void)?
    let refreshCompletion: (() -> Void)?
    
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
        let eventImageURL: String
        let datePeriod: String
        let placeFullName: String
    }
    
    struct ActualProps {
        let imageUrl: String
        let actualTitle: String
        let actualDescription: String
    }
    
    struct HeaderProps {
        let headerTitle: String
        let watchingAllCompletion: (() -> Void)?
    }
    
    struct LocationViewProps {
        let locationName: String
        let locationViewTapCompletion: (() -> Void)
    }
}

protocol MainViewControllerProtocol: AnyObject {
    func render(with props: MainViewControllerProps)
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    // MARK: - Properties
    var initialCompletion: (() -> Void)?
    var logOutAction: (() -> Void)?
    private var sections: [MainViewControllerProps.Section] = []
    private var actualTapCompletion: ((MainViewControllerProps.ActualProps) -> Void)?
    private var refreshCompletion: (() -> Void)?
    
    // MARK: - Views
    private let profileView = ProfileView()
    private let locationView = LocationTrackingView()
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let errorView = ErrorView()
    private let loadingView = LoadingView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
        addObservers()
        initialCompletion?()
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
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.register(cellWithClass: HorizontalTableViewCell.self)
            $0.register(cellWithClass: ActualTableViewCell.self)
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
        
        refreshControl.do {
            
            $0.tintColor = Colors.accentColor.color
            $0.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
    
        errorView.do {
            $0.isHidden = true
        }
        
        loadingView.do {
            $0.isHidden = false
        }
    }
    
    func addViews() {
        view.addSubviews([locationView, tableView, errorView, loadingView])
        tableView.addSubviews([refreshControl])
    }
    
    func setupConstraints() {
        
        profileView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(39)
        }
        
        locationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(locationView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLogOut),
            name: .logOut,
            object: nil
        )
    }
    
    func applyProps(props: MainViewControllerProps) {
        sections = props.sections
        
        profileView.render(with: props.profileViewProps)
        
        actualTapCompletion = props.actualTapCompletion
        refreshCompletion = props.refreshCompletion
        
        if let locationViewProps = props.locationViewProps {
            locationView.render(with: locationViewProps)
        } else {
            
        }
        
        let state = props.mainViewControllerState
        tableView.animated(hide: state != .success)
        errorView.animated(hide: state != .error)
        loadingView.animated(hide: state != .loading)
        if !tableView.isHidden {
            refreshControl.endRefreshing()
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Actions
    @objc func handleRefreshControl() {
        refreshCompletion?()
    }
    
    @objc func handleLogOut() {
        logOutAction?()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
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
            return cell
        } else {
            let cell = tableView.dequeueCell(withClass: HorizontalTableViewCell.self, for: indexPath) as HorizontalTableViewCell
            cell.render(with: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section]
        
        if case .news = item {
            return 145
        } else if case .events = item {
            return 355
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
            if let current = headers?[section - 1] {
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
            return 0
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 2 {
            let section = sections[indexPath.section]
            
            if case .actual(let actual) = section, let actual = actual {
                DispatchQueue.main.async { [weak self] in
                    self?.actualTapCompletion?(actual[indexPath.row])
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 25
        }
        return 0
    }
}

extension Notification.Name {
    static let logOut = Notification.Name("logOut")
}
