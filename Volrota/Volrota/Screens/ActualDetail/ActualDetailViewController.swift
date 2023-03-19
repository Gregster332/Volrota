// 
//  ActualDetailViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

protocol ActualDetailViewControllerProtocol: AnyObject {
    func render(with props: ActualDetailViewController.ActualDetailViewControllerProps)
}

final class ActualDetailViewController: UIViewController, ActualDetailViewControllerProtocol {
    
    struct ActualDetailViewControllerProps {
        let descriptionText: String
    }
    
    // MARK: - Properties
    
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ActualDetailPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    
    // MARK: - Views
    
    private let label = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    
    func render(with props: ActualDetailViewControllerProps) {
        label.text = props.descriptionText
    }
}

// MARK: - Private Methods

private extension ActualDetailViewController {
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        label.do {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
    func addViews() {
        view.addSubviews([label])
    }
    
    func setupConstraints() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - UI Actions

}
