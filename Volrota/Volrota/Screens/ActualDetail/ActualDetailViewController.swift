// 
//  ActualDetailViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import Kingfisher

struct ActualDetailViewControllerProps {
    
    let sections: [Section]
    
    enum Section {
        case descriptionSection(DescriptionSectionProps)
        case imageSection(ImageSectionProps)
    }
    
    struct DescriptionSectionProps {
        let sectionTitle: String
        let descriptionText: String
    }
    
    struct ImageSectionProps {
        let imageUrl: String
    }
    
//    let imageUrl: String
//    let actualTitle: String
//    let descriptionText: String
}

protocol ActualDetailViewControllerProtocol: AnyObject {
    func render(with props: ActualDetailViewControllerProps)
}

final class ActualDetailViewController: UIViewController, ActualDetailViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ActualDetailPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var sections: [ActualDetailViewControllerProps.Section] = []
    
    // MARK: - Views
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let headerView = ActualTitleHeader()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with props: ActualDetailViewControllerProps) {
        sections = props.sections
//        imageView.kf.setImage(with: URL(string: props.imageUrl))
//        titleLabel.text = props.actualTitle
//        descriptionTextView.text = props.descriptionText
    }
}

// MARK: - Private Methods
private extension ActualDetailViewController {
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(cellWithClass: ActualDescriptionCell.self)
            $0.register(cellWithClass: ActualImageCell.self)
            $0.delegate = self
            $0.dataSource = self
            $0.sectionHeaderHeight = UITableView.automaticDimension
            $0.estimatedSectionHeaderHeight = 70
        }
    }
    
    func addViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ActualDetailViewController: UITableViewDelegate {
    
}

extension ActualDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section]
        
        switch item {
        case .descriptionSection(let descriptionProps):
            let cell = tableView.dequeueCell(withClass: ActualDescriptionCell.self, for: indexPath) as ActualDescriptionCell
            cell.render(with: descriptionProps.descriptionText)
            return cell
        case .imageSection(let imageProps):
            let cell = tableView.dequeueCell(withClass: ActualImageCell.self, for: indexPath) as ActualImageCell
            cell.render(with: imageProps.imageUrl)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = sections[section]
        
        switch item {
        case .imageSection:
            return nil
        case .descriptionSection(let descriptionProps):
            headerView.render(with: descriptionProps.sectionTitle)
            return headerView
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .regular)], context: nil)
    
        return ceil(boundingBox.height)
    }
}
