// 
//  MainViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit
import FirebaseFirestore

protocol MainViewControllerProtocol: AnyObject {
    func render(with props: MainViewController.MainViewControllerProps)
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    struct MainViewControllerProps {
        let profileViewTitle: String
        var sections: [Section]
        let mainViewControllerState: MainViewControllerState
        let profileTapCompletion: (() -> Void)?
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
        
        struct NewsViewProps: CustomStringConvertible {
        
            let title: String
            let bannerTitle: String
            let viewBackgroundColor: UIColor
            let bannerBackgroundColor: UIColor
            let titleColor: UIColor
            let bannerTitleColor: UIColor
            
            var description: String {
                return title
            }
            
            init(_ dictionary: [String: Any]) {
                title = dictionary["title"] as? String ?? ""
                bannerTitle = dictionary["banner_title"] as? String ?? ""
                viewBackgroundColor = UIColor(dictionary["bg_color"] as? String ?? "")
                bannerBackgroundColor = UIColor(dictionary["banner_bg_color"] as? String ?? "")
                titleColor = UIColor(dictionary["title_color"] as? String ?? "")
                bannerTitleColor = UIColor(dictionary["banner_title_color"] as? String ?? "")
            }
        }
        
        struct EventViewProps: CustomStringConvertible {
            
            let eventTitle: String
            let eventImageURL: String
            let startDate: Timestamp
            let endDate: Timestamp
            let lat: Double
            let long: Double
            
            var description: String {
                return eventTitle
            }
            
            init(_ dictionary: [String: Any]) {
                //print(dictionary["start_date"])
                eventTitle = dictionary["title"] as? String ?? ""
                eventImageURL = dictionary["image"] as? String ?? ""
                startDate = dictionary["start_date"] as? Timestamp ?? Timestamp()
                endDate = dictionary["end_date"] as? Timestamp ?? Timestamp()
                lat = dictionary["lat"] as? Double ?? 0.0
                long = dictionary["long"] as? Double ?? 0.0
            }
        }
        
        struct ActualProps {
            let image: UIImage
            let actualTitle: String
            let actualLongRead: String
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
    private var actualTapCompletion: ((MainViewControllerProps.ActualProps) -> Void)?
    private var refreshCompletion: (() -> Void)?
    
    // MARK: - Views
    
    private let profileView = ProfileView()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        refreshControl.do {
            $0.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
        view.addSubviews([tableView, errorView, loadingView])
        tableView.addSubviews([refreshControl])
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
        actualTapCompletion = props.actualTapCompletion
        refreshCompletion = props.refreshCompletion
        
        let state = props.mainViewControllerState
        tableView.animated(hide: state != .success)
        errorView.animated(hide: state != .error)
        loadingView.animated(hide: state != .loading)
        if !tableView.isHidden {
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - UI Actions
    
    @objc func handleTapOnProfileView() {
        profileTapCompletion?()
    }
    
    @objc func handleRefreshControl() {
        refreshCompletion?()
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
            return 145
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
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            let section = sections[indexPath.section]
            
            if case .actual(let actual) = section, let actual = actual {
                DispatchQueue.main.async {
                    self.actualTapCompletion?(actual[indexPath.row])
                }
            }
        }
    }
}

extension UIColor {
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000")
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
