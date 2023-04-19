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
    let actualTapCompletion: ((IndexPath) -> Void)?
    let refreshCompletion: (() -> Void)?
    
    enum Section {
        case news([NewsViewProps])
        case actual([ActualProps])
        case header([HeaderProps])
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
    private var actualTapCompletion: ((IndexPath) -> Void)?
    private var refreshCompletion: (() -> Void)?
    private var layoutSections: [MainSection] = [
        NewsSection(),
        ActualsSection()
    ]
    
    // MARK: - Views
    private let profileView = ProfileView()
    private let locationView = LocationTrackingView()
    private let refreshControl = UIRefreshControl()
    private let errorView = ErrorView()
    private let loadingView = LoadingView()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { (index, _) -> NSCollectionLayoutSection? in
            return self.layoutSections[index].layoutSection()
        }
        return layout
    }()
    
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
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.register(cellWithClass: NewsCollectionViewCell.self)
            $0.register(cellWithClass: ActualCollectionViewCell.self)
            $0.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withClass: CollectionViewHeaderView.self
            )
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
        view.addSubviews([locationView, collectionView, errorView, loadingView])
        collectionView.addSubviews([refreshControl])
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
        
        collectionView.snp.makeConstraints {
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
        collectionView.animated(hide: state != .success)
        errorView.animated(hide: state != .error)
        loadingView.animated(hide: state != .loading)
        if !collectionView.isHidden {
            refreshControl.endRefreshing()
            collectionView.reloadData()
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = sections[section]
        
        switch item {
        case .news(let newsProps):
            return newsProps.count
        case .actual(let actualsProps):
            return actualsProps.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section]
        
        switch item {
        case .news(let newsProps):
            let cell = collectionView.dequeueCell(with: indexPath) as NewsCollectionViewCell
            cell.render(with: newsProps[indexPath.item])
            return cell
        case .actual(let actualsProps):
            let cell = collectionView.dequeueCell(with: indexPath) as ActualCollectionViewCell
            cell.render(with: actualsProps[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1 {
            let section = sections[indexPath.section]
            
            if case .actual = section {
                //DispatchQueue.main.async { [weak self] in
                    self.actualTapCompletion?(indexPath)
               // }
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let item = sections.last
        switch item {
        case .header(let headerProps):
            //if indexPath.section == 1 {
                let headerView = collectionView.dequeueSupplementaryView(
                    ofKind: kind,
                    for: indexPath) as CollectionViewHeaderView
                headerView.render(with: headerProps[indexPath.section - 1])
                return headerView
//            } else {
//                let headerView = collectionView.dequeueSupplementaryView(
//                    ofKind: kind,
//                    for: indexPath) as CollectionViewHeaderView
//                headerView.render(with: headerProps[indexPath.section])
//                return headerView
//            }
        default:
            return UICollectionReusableView()
        }
        
    }
}

extension Notification.Name {
    static let logOut = Notification.Name("logOut")
}
