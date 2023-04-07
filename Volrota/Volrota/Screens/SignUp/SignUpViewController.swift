// 
//  SignUpViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import UIKit

struct SignUpViewControllerProps {
    let sections: [SignUpSection]
    let borderedButtonProps: BorderedButtonProps?
    let selectImageCompletion: ((UIImage) -> Void)?
    
    enum SignUpSection {
        case typing(TypingSection)
        case dropDown(OrganizationSection)
    }
    
    struct TypingSection {
        let title: String
    }
    
    struct OrganizationSection {
        let title: String
        let cellProps: OrganizationsCellProps
    }
}

protocol SignUpViewControllerProtocol: AnyObject {
    func render(with props: SignUpViewControllerProps)
}

final class SignUpViewController: UIViewController, SignUpViewControllerProtocol {
    
    // MARK: - Properties
    
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: SignUpPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var sections: [SignUpViewControllerProps.SignUpSection] = []
    private var selectImageCompletion: ((UIImage) -> Void)?
    
    // MARK: - Views
    private let changeProfileButtonView = UIButton()
    private let tableView = UITableView()
    private let signUpButton = BorderedButton()
    private let imagePicker = UIImagePickerController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
        presenter.initialAction()
    }
    
    // MARK: - Methods
    func render(with props: SignUpViewControllerProps) {
        sections = props.sections
        selectImageCompletion = props.selectImageCompletion
        signUpButton.render(with: props.borderedButtonProps)
        tableView.reloadData()
    }
}

// MARK: - Private Methods

private extension SignUpViewController {
    
    func setupView() {
        
        self.do {
            $0.title = "Регистрация"
        }
        
        view.do {
            $0.backgroundColor = .white
        }
        
        changeProfileButtonView.do {
            $0.setImage(Images.bred.image, for: .normal)
            $0.layer.cornerRadius = 60
            $0.imageView?.contentMode = .scaleAspectFill
            $0.imageView?.layer.cornerRadius = 60
            // TODO: Переделать
            $0.addTarget(self, action: #selector(handleImageViewTap), for: .touchUpInside)
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellWithClass: TypingCell.self)
            $0.register(cellWithClass: OrganizationsCell.self)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.isScrollEnabled = true
        }
        
        signUpButton.addTarget(target: self, action: #selector(handleSignUpButton), for: .touchUpInside)
    }
    
    func addViews() {
        
        view.addSubview(changeProfileButtonView)
        view.addSubview(tableView)
        view.addSubview(signUpButton)
    }
    
    func setupConstraints() {
        
        changeProfileButtonView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(changeProfileButtonView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(signUpButton.snp.top).offset(-8)
        }
    }
    
    // MARK: - UI Actions
    @objc func handleSignUpButton() {
        presenter.signUp(
            tableView.getStringFromTextField(with: 0),
            tableView.getStringFromTextField(with: 1),
            tableView.getStringFromTextField(with: 2),
            tableView.getStringFromTextField(with: 3),
            tableView.getStringFromTextField(with: 4),
            changeProfileButtonView.imageView?.image ?? UIImage()
        )
    }
    
    @objc func handleImageViewTap() {
        //if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        //}
    }
}

extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .typing(let typingSection):
            let cell = tableView.dequeueCell(withClass: TypingCell.self, for: indexPath) as TypingCell
            cell.render(tag: indexPath.section)
            return cell
        case .dropDown(let dropDownSection):
            let cell = tableView.dequeueCell(withClass: OrganizationsCell.self, for: indexPath) as OrganizationsCell
            cell.render(with: dropDownSection.cellProps)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .typing(let typingSection):
            return typingSection.title
        case .dropDown(let dropDownSection):
            return dropDownSection.title
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        24
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.changeProfileButtonView.setImage(imagePicked, for: .normal)
        }
        
        self.dismiss(animated: true)
    }
}
