// 
//  EventsViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/8/23.
//

import UIKit

struct EventsViewControllerProps {
    let events: [EventsSection]
    let eventTapCompletion: ((IndexPath) -> Void)?
    let tapOnAddEventCompletion: (() -> Void)?
    
    enum EventsSection {
        case others([EventItem])
        
        var headerTitle: String {
            switch self {
            case .others:
                return "Общие"
            }
        }
    }
    
    struct EventItem: Hashable {
        let name: String
        let imageUrl: String
        let date: String
        let place: String
    }
}

protocol EventsViewControllerProtocol: AnyObject {
    func render(with props: EventsViewControllerProps)
}

final class EventsViewController: UIViewController, EventsViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: EventsPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var sections: [EventsViewControllerProps.EventsSection] = []
    private var eventTapCompletion: ((IndexPath) -> Void)?
    private var tapOnAddEventCompletion: (() -> Void)?
    
    // MARK: - Views
    private let layout = UICollectionViewLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let filterButton = UIButton(type: .custom)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.initialize()
    }
    
    // MARK: - Methods
    func render(with props: EventsViewControllerProps) {
        sections = props.events
        eventTapCompletion = props.eventTapCompletion
        tapOnAddEventCompletion = props.tapOnAddEventCompletion
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
}

// MARK: - Private Methods
private extension EventsViewController {
    
    func setupView() {
        
        self.do {
            $0.title = Strings.Events.navTitle
        }
        
        view.do {
            $0.backgroundColor = .white
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: EventCell.self)
            $0.register(
                supplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withClass: EventsSectionHeader.self)
            $0.dataSource = self
            $0.delegate = self
            $0.collectionViewLayout = createLayout()
            $0.allowsMultipleSelection = true
        }
        
        filterButton.do {
            $0.menu = createMenu()
            $0.showsMenuAsPrimaryAction = true
            $0.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        }
        
        setNavigationBar()
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: filterButton),
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(handleTapOnCreateNewUser)
            )
        ]
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, _) -> NSCollectionLayoutSection? in
            return self?.createSection()
        }
        return layout
    }
    
    func createSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 8
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(335)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(
            group: group
        )
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = spacing
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(45)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createMenu(actionTitle: String? = nil) -> UIMenu {
        let menu = UIMenu(title: "Фильтры", options: [.displayInline], children: [
            UIAction(title: "Уже участвую") { [unowned self] action in
                self.presenter.filterEvents(with: 0)
                self.filterButton.menu = self.createMenu(actionTitle: action.title)
            },
            UIAction(title: "Скоро истечет") { [unowned self] action in
                self.presenter.filterEvents(with: 1)
                self.filterButton.menu = self.createMenu(actionTitle: action.title)
            },
        ])
        
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    action.state = .on
                }
            }
        }
        
        return menu
    }
    
    @objc func handleTapOnCreateNewUser() {
        tapOnAddEventCompletion?()
    }
}

extension EventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventTapCompletion?(indexPath)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension EventsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .others(let events):
            return events.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .others(let events):
            let item = events[indexPath.item]
            let cell = collectionView.dequeueCell(with: indexPath) as EventCell
            cell.render(with: item)
            return cell
        }
    }
}

extension EventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath) as EventsSectionHeader
        let title = sections[indexPath.section].headerTitle
        headerView.configure(title: title)
        return headerView
    }
}
