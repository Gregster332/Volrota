// 
//  ProfileViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import Kingfisher
import Lottie
import Photos
import PhotosUI

struct ProfileViewControllerProps {
    var isLoading: Bool
    var cells: [ProfileCell]
    var isEditingMode: Bool
    var isPhotoPickerPresented: Bool
    let didEndPhotoPicking: ((UIImage) -> Void)?
    
    enum ProfileCell {
        case user(UserCellProps)
        case organization(OrganizationCell)
        case options([ProfileSettingsCell])
    }
    
    struct ProfileSettingsCell {
        let title: String
        let textColor: UIColor
        let action: (() -> Void)?
    }
    
    struct UserCellProps {
        var profileImageUrl: String
        var fullName: String
        let changeUserNameAction: (() -> Void)?
        let changeUserImageAction: (() -> Void)?
        let didEndEditingAction: ((String) -> Void)?
    }
    
    struct OrganizationCell {
        let organizationName: String
        let organizationImageUrl: String
    }
}

protocol ProfileViewControllerProtocol: AnyObject {
    func render(with props: ProfileViewControllerProps)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ProfilePresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var cells: [ProfileViewControllerProps.ProfileCell] = []
    private let layoutSections: [ProfileSection] = [
        UserSection(),
        OrganizationSection(),
        OptionsSection()
    ]
    private var isEditingMode: Bool = false
    private var didEndPhotoPicking: ((UIImage) -> Void)?
    
    // MARK: - Views
    private let loadingView = LoadingView()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { (index, _) -> NSCollectionLayoutSection? in
            return self.layoutSections[index].createSection()
        }
        return layout
    }()
    private var pickerConfig = PHPickerConfiguration(photoLibrary: .shared())
    private lazy var picker = PHPickerViewController(configuration: pickerConfig)
    private let backButton = UIButton(type: .custom)
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        addViews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.initialize()
    }
    
    // MARK: - Methods
    func render(with props: ProfileViewControllerProps) {
        
        if props.isLoading {
            loadingView.layer.opacity = 1
            collectionView.layer.opacity = 0
            backButton.isEnabled = false
        } else {
            backButton.isEnabled = true
            isEditingMode = props.isEditingMode
            
            if props.isPhotoPickerPresented {
                presenter.presentPhotoPicker(picker: picker)
            }
            
            didEndPhotoPicking = props.didEndPhotoPicking
            loadingView.layer.opacity = 0
            collectionView.layer.opacity = 1
            cells = props.cells
            collectionView.reloadData()
        }
    }
}

// MARK: - Private Methods
private extension ProfileViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: UserCell.self)
            $0.register(cellWithClass: OrganizationCell.self)
            $0.register(cellWithClass: OptionsViewCell.self)
        }
        
        pickerConfig.selectionLimit = 1
        pickerConfig.filter = PHPickerFilter.any(of: [.images])
        
        picker.do {
            $0.delegate = self
        }
        
        backButton.do {
            let backButtonImage = UIImage(
                systemName: "xmark"
            )?.withRenderingMode(.alwaysTemplate)
            $0.setImage(backButtonImage, for: .normal)
            $0.addTarget(
                self,
                action: #selector(handleTapOnClose),
                for: .touchUpInside
            )
            $0.frame.size.width = 80
            $0.contentHorizontalAlignment = .leading
        }
    }
    
    func addViews() {
        view.addSubview(collectionView)
        view.addSubview(loadingView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func handleTapOnClose() {
        presenter.dismiss()
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = cells[indexPath.section]
        
        switch item {
        case .options(let options):
            let option = options[indexPath.item]
            option.action?()
        default:
            break
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = cells[section]
        
        switch section {
        case .user:
            return 1
        case .organization:
            return 1
        case .options(let options):
            return options.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = cells[indexPath.section]
        
        switch section {
        case .user(let userProps):
            let cell = collectionView.dequeueCell(with: indexPath) as UserCell
            cell.render(with: userProps, isEditingMode: isEditingMode)
            return cell
        case .organization(let organizationProps):
            let cell = collectionView.dequeueCell(with: indexPath) as OrganizationCell
            cell.render(with: organizationProps)
            return cell
        case .options(let options):
            let item = options[indexPath.item]
            let cell = collectionView.dequeueCell(with: indexPath) as OptionsViewCell
            cell.render(with: item)
            return cell
        }
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true, completion: .none)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.presenter.openErrorAlert(with: error.localizedDescription)
                    }
                    if let image = reading as? UIImage {
                        self.didEndPhotoPicking?(image)
                    }
                }
            }
        }
    }
}
