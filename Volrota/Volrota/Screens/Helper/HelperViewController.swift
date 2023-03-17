// 
//  HelperViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

protocol HelperViewControllerProtocol: AnyObject {
}

final class HelperViewController: UIViewController, HelperViewControllerProtocol {
    
    // MARK: - Properties
    
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: HelperPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    
    // MARK: - Views

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods

}

// MARK: - Private Methods

private extension HelperViewController {
    
    func setupView() {
        view.backgroundColor = .red
    }
    
    func addViews() {
    }
    
    func setupConstraints() {
    }
    
    // MARK: - UI Actions

}
