// 
//  EventDetailViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/14/23.
//

import UIKit

struct EventDetailViewControllerProps {
    let sections: [EventDetailSection]
    let didTapOnLocation: (() -> Void)?
    let eventState: State
    
    enum EventDetailSection {
        case imageTitle(ImageTitleSection)
        case description(DescriptionSection)
        case location(LocationSection)
        case subscribeEvent(SubscribeEventSection)
    }
    
    enum State {
        case subscribed
        case expired
        case available
    }
    
    struct ImageTitleSection {
        let imageUrl: String
        let titleText: String
    }
    
    struct DescriptionSection {
        let descriptionText: String
        let startDate: String
        let endDate: String
    }
    
    struct LocationSection {
        let lat: Double
        let long: Double
    }
    
    struct SubscribeEventSection {
        let state: State
        let didTapOnSubscribe: (() -> Void)?
    }
}

protocol EventDetailViewControllerProtocol: AnyObject {
    func render(with props: EventDetailViewControllerProps)
}

final class EventDetailViewController: UIViewController, EventDetailViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: EventDetailPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var layoutSections: [EventDetailLayoutSection] = [
        ImageTitleSection(),
        DescriptionSection(),
        LocationSection(),
        SubscriptionSection()
    ]
    private var sections: [EventDetailViewControllerProps.EventDetailSection] = []
    private var didTapOnLocation: (() -> Void)?
    
    // MARK: - Views
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.layoutSections[index].createSection()
        }
        return layout
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with props: EventDetailViewControllerProps) {
        sections = props.sections
        didTapOnLocation = props.didTapOnLocation
        collectionView.reloadData()
    }
}

// MARK: - Private Methods
private extension EventDetailViewController {
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: EventTitleCell.self)
            $0.register(cellWithClass: EventDescriptionCell.self)
            $0.register(cellWithClass: EventLocationCell.self)
            $0.register(cellWithClass: EventSubscriptionCell.self)
        }
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension EventDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section]
        
        switch item {
        case .location:
            didTapOnLocation?()
        default:
            break
        }
    }
    
}

extension EventDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section]
        
        switch item {
        case .imageTitle(let imageTitleProps):
            let cell = collectionView.dequeueCell(with: indexPath) as EventTitleCell
            cell.render(with: imageTitleProps)
            return cell
        case .description(let descriptionProps):
            let cell = collectionView.dequeueCell(with: indexPath) as EventDescriptionCell
            cell.render(with: descriptionProps)
            return cell
        case .location(let locationProps):
            let cell = collectionView.dequeueCell(with: indexPath) as EventLocationCell
            cell.render(with: locationProps)
            return cell
        case .subscribeEvent(let subsriptionProps):
            let cell = collectionView.dequeueCell(with: indexPath) as EventSubscriptionCell
            cell.render(with: subsriptionProps)
            return cell
        }
    }    
}
