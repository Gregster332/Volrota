// 
//  AuthViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import UIKit

struct AuthViewControllerProps {

    let sections: [TypingSection]
    let titleText: String
    let signUpButtonAction: (() -> Void)?
    var borderedButtonProps: BorderedButtonProps?
    
    struct TypingSection {
        let title: String
        let cellProps: TypingCellProps?
    }
}

protocol AuthViewControllerProtocol: AnyObject {
    func render(with props: AuthViewControllerProps?)
}

final class AuthViewController: UIViewController, AuthViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: AuthPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    var initialAction: (() -> Void)?
    private var sections: [AuthViewControllerProps.TypingSection] = []
    private var signUpButtonAction: (() -> Void)?
    
    // MARK: - Views
    private let titelLabel = UILabel()
    private let tableView = UITableView()
    private let signInButton = BorderedButton()
    private let signUpButton = UIButton()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.initialAction()
    }
    
    // MARK: - Methods
    func render(with props: AuthViewControllerProps?) {
        sections = props?.sections ?? []
        titelLabel.text = props?.titleText
        signUpButtonAction = props?.signUpButtonAction
        signInButton.render(with: props?.borderedButtonProps)
        tableView.reloadData()
    }
}

// MARK: - Private Methods
private extension AuthViewController {
    
    func setupView() {
        
        self.do {
            $0.navigationItem.hidesBackButton = true
        }
        
        view.do {
            $0.backgroundColor = .white
        }
        
        titelLabel.do {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellWithClass: TypingCell.self)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
        }
        
        signInButton.addTarget(target: self, action: #selector(handleSignInButton), for: .touchUpInside)
        
        signUpButton.do {
            $0.setTitle(Strings.Auth.createAccount, for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        }
        
    }
    
    func addViews() {
        
        view.addSubview(titelLabel)
        view.addSubview(tableView)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    
    func setupConstraints() {
        
        titelLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        signInButton.snp.makeConstraints {
            $0.bottom.equalTo(signUpButton.snp.top).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titelLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(signInButton.snp.top).offset(-10)
        }
    }
    
    // MARK: - UI Actions
    @objc func handleSignInButton() {
        let email = tableView.getStringFromTextField(with: 0)
        let password = tableView.getStringFromTextField(with: 1)
        
        presenter.signIn(email, password)
    }
    
    @objc func handleSignUpButton() {
        
        signUpButtonAction?()
    }
}

extension AuthViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section]
        let cell = tableView.dequeueCell(withClass: TypingCell.self, for: indexPath) as TypingCell
        cell.render(with: item.cellProps)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        24
    }
}
