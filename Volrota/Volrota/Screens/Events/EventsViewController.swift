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
    let filterTapCompletiom: ((Int) -> Void)?
    
    enum EventsSection {
        case filter([String])
        case events([EventItem])
    }
    
    struct EventItem {
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
    private var filterTapCompletiom: ((Int) -> Void)?
    
    // MARK: - Views
    private let layout = UICollectionViewLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

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
        filterTapCompletiom = props.filterTapCompletiom
        if collectionView.numberOfSections > 0 {
            collectionView.reloadSections(IndexSet(integer: 1))
        } else {
            collectionView.reloadData()
        }
    }
}

// MARK: - Private Methods

private extension EventsViewController {
    
    func setupView() {
        
        self.do {
            $0.title = "Мероприятия"
        }
        
        view.do {
            $0.backgroundColor = .white
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: EventCell.self)
            $0.register(cellWithClass: FilteringCell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.collectionViewLayout = createLayout()
        }
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, _) -> NSCollectionLayoutSection? in
            if index == 0 {
                return self?.createFilterSection()
            } else {
                return self?.createSection()
            }
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
        
        return section
    }
    
    func createFilterSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 8
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .estimated(100),
                heightDimension: .absolute(35)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(35)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(
            group: group
        )
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = spacing
        
        return section
    }
    
    // MARK: - UI Actions

}

extension EventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            eventTapCompletion?(indexPath)
        } else {
            let cell = collectionView.cellForItem(at: indexPath)
            if ((cell?.isSelected) != nil) {
                filterTapCompletiom?(indexPath.item)
                //
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
            
        }
    }
}

extension EventsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .filter(let filters):
            return filters.count
        case .events(let events):
            return events.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .filter(let filters):
            let item = filters[indexPath.item]
            let cell = collectionView.dequeueCell(with: indexPath) as FilteringCell
            cell.render(with: item)
            return cell
        case .events(let events):
            let item = events[indexPath.item]
            let cell = collectionView.dequeueCell(with: indexPath) as EventCell
            cell.render(with: item)
            return cell
        }
    }
}

extension EventsViewController: UICollectionViewDelegateFlowLayout {
    
}
