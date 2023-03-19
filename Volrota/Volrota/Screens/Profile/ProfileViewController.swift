// 
//  ProfileViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    
    func render(with props: ProfileViewController.ProfileProps)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    struct ProfileProps {
        
        let avatarImage: UIImage
        let userName: String
        let closeButtonAction: (() -> Void)
        let cells: [ProfileCell]
        
        struct ProfileCell {
            let title: String
            let action: (() -> Void)?
        }
        
    }
    
    // MARK: - Properties
    
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ProfilePresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var cells: [ProfileProps.ProfileCell] = []
    private var closeButtonAction: (() -> Void)?
    
    // MARK: - Views
    
    private let closeButton = UIButton()
    private let avatarImage = UIImageView()
    private let userNameLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
        configureBarItems()
    }
    
    // MARK: - Methods
    
    func render(with props: ProfileViewController.ProfileProps) {
        avatarImage.image = props.avatarImage
        userNameLabel.text = props.userName
        closeButtonAction = props.closeButtonAction
        cells = props.cells
    }
}

// MARK: - Private Methods

private extension ProfileViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        closeButton.do {
            $0.setImage(Images.close.image, for: .normal)
            $0.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        }
        
        avatarImage.do {
            $0.layer.cornerRadius = 75
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
        }
        
        userNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .center
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.separatorStyle = .singleLine
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: ProfileTableViewCell.self)
        }
    }
    
    func addViews() {
        view.addSubviews([avatarImage, userNameLabel, tableView])
    }
    
    func setupConstraints() {
        
        avatarImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.size.equalTo(150)
            $0.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    // MARK: - UI Actions
    
    @objc func handleCloseButton() {
        closeButtonAction?()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withClass: ProfileTableViewCell.self, for: indexPath) as ProfileTableViewCell
        let item = cells[indexPath.row]
        cell.render(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = cells[indexPath.row]
        item.action?()
    }
}
