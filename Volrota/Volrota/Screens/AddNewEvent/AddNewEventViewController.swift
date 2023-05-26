// 
//  AddNewEventViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/25/23.
//

import UIKit
import PhotosUI
import FloatingPanel
import GeneralServices

struct AddNewEventViewControllerProps {
    let sections: [Section]
    let didTapOnSaveButtonCompletion: (() -> Void)?
    
    enum Section: CaseIterable {
        case title
        case image
        case date
        case location
    }
}

protocol AddNewEventViewControllerProtocol: AnyObject {
    func render(with props: AddNewEventViewControllerProps)
    func didChangeImage()
    func didChangeTitle()
    func makeLocationsList(locations: [LocationModel])
}

final class AddNewEventViewController: UIViewController, AddNewEventViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: AddNewEventPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private let layoutSections: [AddNewEventSection] = [
        AddNewEventTitleSection(),
        AddNewEventImageSection(),
        AddNewEventDatesSection(),
        AddNewEventLocationSection()
    ]
    private var sections: [AddNewEventViewControllerProps.Section] = []
    private var didTapOnSaveButtonCompletion: (() -> Void)?
    
    // MARK: - Views
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, _) -> NSCollectionLayoutSection? in
            return self?.layoutSections[index].createLayout()
        }
        return layout
    }()
    private var pickerConfig = PHPickerConfiguration(photoLibrary: .shared())
    private lazy var picker = PHPickerViewController(configuration: pickerConfig)
    private let saveEventButton = UIButton(type: .custom)
    private let panel = FloatingPanelController()
    private let findLocationController = FindLocationController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        panel.do {
            $0.set(contentViewController: findLocationController)
            $0.isRemovalInteractionEnabled = true
            $0.surfaceView.roundCorners([.topLeft, .topRight], radius: 12)
        }
    }
    
    // MARK: - Methods
    func render(with props: AddNewEventViewControllerProps) {
        sections = props.sections
        didTapOnSaveButtonCompletion = props.didTapOnSaveButtonCompletion
    }
    
    func didChangeImage() {
        collectionView.reloadSections(IndexSet(integer: 1))
    }
    
    func didChangeTitle() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func makeLocationsList(locations: [LocationModel]) {
        findLocationController.configure(with: locations)
    }
}

// MARK: - Private Methods
private extension AddNewEventViewController {
    
    func setupView() {
        self.do {
            $0.title = "Создать событие"
        }
        
        view.do {
            $0.backgroundColor = .white
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellWithClass: AddEventTitleCell.self)
            $0.register(cellWithClass: AddEventImageCell.self)
            $0.register(cellWithClass: AddEventDateCell.self)
            $0.register(cellWithClass: AddEventLocationCell.self)
            $0.register(
                supplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withClass: AddEventHeaderView.self)
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
        }
        
        pickerConfig.selectionLimit = 1
        pickerConfig.filter = PHPickerFilter.any(of: [.images])
        
        picker.do {
            $0.delegate = self
        }
        
        saveEventButton.do {
            $0.setTitle("Добавить", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = Colors.accentColor.color
            $0.addTarget(self, action: #selector(didTapOnSaveButton), for: .touchUpInside)
            $0.layer.cornerRadius = 12
        }
        
        findLocationController.do {
            $0.delegate = self
        }
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(saveEventButton)
        
        saveEventButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(saveEventButton.snp.top)
        }
    }
    
    @objc func didTapOnSaveButton() {
        didTapOnSaveButtonCompletion?()
    }
}

extension AddNewEventViewController: UICollectionViewDelegate {
    
}

extension AddNewEventViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = sections[section]
        
        switch item {
        case .title, .image, .location:
            return 1
        case .date:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section]
        
        switch item {
        case .title:
            let cell = collectionView.dequeueCell(with: indexPath) as AddEventTitleCell
            cell.setupTextFiledDelegate(self)
            return cell
        case .image:
            let cell = collectionView.dequeueCell(with: indexPath) as AddEventImageCell
            cell.render(cellDelegate: self, image: presenter.selectedImage)
            return cell
        case .date:
            let cell = collectionView.dequeueCell(with: indexPath) as AddEventDateCell
            if indexPath.item == 0 {
                cell.configure(with: "Дата начала события", date: Date())
                cell.didChangeDate = { [weak self] startDate in
                    self?.presenter.startDate = startDate
                }
            } else {
                cell.configure(with: "Дата окончания события", date: Date())
                cell.didChangeDate = { [weak self] endDate in
                    self?.presenter.endDate = endDate
                }
            }
            return cell
        case .location:
            let cell = collectionView.dequeueCell(with: indexPath) as AddEventLocationCell
            cell.configure(with: self, placeName: presenter.selectedLocation.title)
            return cell
        }
    }
}

extension AddNewEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let item = sections[indexPath.section]
        
        switch item {
        case .title:
            let headerView = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath) as AddEventHeaderView
            headerView.render(with: "Название события")
            return headerView
        case .image:
            let headerView = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath) as AddEventHeaderView
            headerView.render(with: "Изображение")
            return headerView
        case .date:
            let headerView = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath) as AddEventHeaderView
            headerView.render(with: "Даты")
            return headerView
        case .location:
            let headerView = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath) as AddEventHeaderView
            headerView.render(with: "Место проведения")
            return headerView
        }
    }
}

extension AddNewEventViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.newEventTitle = textField.text
    }
}

extension AddNewEventViewController: AddEventImageCellProtocol {
    func didTapOnSetImage() {
        presenter.handleTapOnSetImage(photoPicker: picker)
    }
}

extension AddNewEventViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                DispatchQueue.main.async {
                    if let image = reading as? UIImage {
                        self.presenter.selectedImage = image
                    }
                }
            }
        }
    }
}

extension AddNewEventViewController: AddEventLocationCellProtocol {
    func didTapOnChangeLocation() {
        present(panel, animated: true)
    }
}

extension AddNewEventViewController: FindLocationControllerDelegate {
    func didEndLocationSelection(with model: LocationModel) {
        presenter.selectedLocation = model
        collectionView.reloadSections(IndexSet(integer: 3))
        panel.dismiss(animated: true)
    }
    
    
    func didEndEditing(text: String?) {
        presenter.findLocations(by: text)
    }
}
