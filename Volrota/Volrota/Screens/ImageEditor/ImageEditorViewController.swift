// 
//  ImageEditorViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/16/23.
//

import UIKit

struct ImageEditorViewControllerProps {
    var filteredImage: UIImage
    let filters: [String]
    let didTapOnFilter: ((IndexPath) -> Void)?
}

protocol ImageEditorViewControllerProtocol: AnyObject {
    func render(with props: ImageEditorViewControllerProps)
    func renderImage(_ image: UIImage)
}

final class ImageEditorViewController: UIViewController, ImageEditorViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ImageEditorPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var filters = [String]()
    private var didTapOnFilter: ((IndexPath) -> Void)?
    
    
    // MARK: - Views
    private var filteredImageView = UIImageView()
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, _)  -> NSCollectionLayoutSection? in
            return self?.createSection()
        }
        return layout
    }()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.saveFilteredImage()
    }
    
    // MARK: - Methods
    func render(with props: ImageEditorViewControllerProps) {
        filters = props.filters
        didTapOnFilter = props.didTapOnFilter
        filteredImageView.image = props.filteredImage
        collectionView.reloadData()
        
        collectionView.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally)
    }
    
    func renderImage(_ image: UIImage) {
        UIView.transition(
            with: filteredImageView,
            duration: 0.3,
            options: .transitionCrossDissolve) {
                self.filteredImageView.image = image
        }
    }
}

// MARK: - Private Methods
private extension ImageEditorViewController {
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        filteredImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.clipsToBounds = true
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellWithClass: FilterCell.self)
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(filteredImageView)
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        filteredImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(collectionView.snp.top)
        }
    }
    
    func createSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .absolute(40)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        section.interGroupSpacing = 8
        return section
    }
    
    // MARK: - UI Actions

}

extension ImageEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapOnFilter?(indexPath)
    }
}

extension ImageEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filter = filters[indexPath.item]
        let cell = collectionView.dequeueCell(with: indexPath) as FilterCell
        cell.configure(with: filter)
        return cell
    }
}
