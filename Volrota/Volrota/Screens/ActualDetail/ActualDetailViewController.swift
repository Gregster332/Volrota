// 
//  ActualDetailViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import Kingfisher

struct ActualDetailViewControllerProps {
    let imageUrl: String
    let actualTitle: String
    let descriptionText: String
}

protocol ActualDetailViewControllerProtocol: AnyObject {
    func render(with props: ActualDetailViewControllerProps)
}

final class ActualDetailViewController: UIViewController, ActualDetailViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: ActualDetailPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    
    // MARK: - Views
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionTextView = UITextView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with props: ActualDetailViewControllerProps) {
        imageView.kf.setImage(with: URL(string: props.imageUrl))
        titleLabel.text = props.actualTitle
        descriptionTextView.text = props.descriptionText
    }
}

// MARK: - Private Methods
private extension ActualDetailViewController {
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.roundCorners([.bottomLeft, .bottomRight], radius: 16)
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.textColor = .black
        }
        
        descriptionTextView.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.showsVerticalScrollIndicator = false
            $0.textAlignment = .left
        }
    }
    
    func addViews() {
        view.addSubviews([imageView, titleLabel, descriptionTextView])
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.frame.size.height * 0.3)
        }
            
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
