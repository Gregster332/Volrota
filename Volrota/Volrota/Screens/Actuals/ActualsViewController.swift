// 
//  ActualsViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/9/23.
//

import UIKit

struct ActualsViewControllerProps {
    let actuals: [ActualProps]
    let didTapOnCellCompletion: ((IndexPath) -> Void)?
    
    struct ActualProps {
        let title: String
        let imageUrl: String
        let cityName: String
    }
}

protocol ActualsViewControllerProtocol: AnyObject {
    func render(with props: ActualsViewControllerProps)
}

final class ActualsViewController: UIViewController, ActualsViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ActualsPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var actuals: [ActualsViewControllerProps.ActualProps] = []
    private var didTapOnCellCompletion: ((IndexPath) -> Void)?
    
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
    func render(with props: ActualsViewControllerProps) {
        actuals = props.actuals
        didTapOnCellCompletion = props.didTapOnCellCompletion
        collectionView.reloadData()
    }
}

// MARK: - Private Methods

private extension ActualsViewController {
    
    func setupView() {
        
        self.do {
            $0.title = "Актуальные"
        }
        
        view.do {
            $0.backgroundColor = .white
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: ActualCell.self)
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
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.createSection()
        }
        return layout
    }
    
    func createSection() -> NSCollectionLayoutSection {
        
        let spacing: CGFloat = 8
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(250)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = spacing
        return section
    }
    
    // MARK: - UI Actions

}

extension ActualsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapOnCellCompletion?(indexPath)
    }
}

extension ActualsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actuals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = actuals[indexPath.item]
        let cell = collectionView.dequeueCell(with: indexPath) as ActualCell
        cell.render(with: item)
        return cell
    }
}
