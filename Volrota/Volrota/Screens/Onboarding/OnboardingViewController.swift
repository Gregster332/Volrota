// 
//  OnboardingViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import UIKit

protocol OnboardingViewControllerProtocol: AnyObject {
    func update(with configurePages: [UIViewController])
    func setupButton(with title: String, backgroundColor: UIColor, textColor: UIColor)
    func setupButtonTitle(with title: String)
}

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: OnboardingPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var borderedButtonAction: (() -> Void)?
    
    // MARK: - Views
    private var pages = [UIViewController]()
    private var continueButton = UIButton()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureControllers()
        setupNavigationBar()
        setupView()
        setupConstraints()
        removeSwipeGesture()
    }
}

// MARK: - Private Methods
private extension OnboardingViewController {
    
    func configureControllers() {
        presenter.configureControllers()

        setViewControllers(
            [pages[presenter.getSelectedIndex()]],
            direction: .forward,
            animated: true
        )
    }
    
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        
        self.do {
            $0.delegate = self
            $0.dataSource = nil
        }
        
        continueButton.do {
            $0.backgroundColor = Colors.accentColor.color
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(
                ofSize: 20,
                weight: .semibold
            )
            $0.layer.cornerRadius = 12
            $0.addTarget(
                self,
                action: #selector(pageDidChanges),
                for: .touchUpInside
            )
        }
    }
    
    func setupConstraints() {
        
        view.addSubview(continueButton)
        
        continueButton.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    func removeSwipeGesture() {
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    // MARK: - UI Actions
    @objc private func pageDidChanges() {
        let currentIndex = presenter.getSelectedIndex()
        presenter.setSelectedIndex(currentIndex + 1)
        if presenter.getSelectedIndex() >= pages.count {
            presenter.nextScreen()
        } else {
            setViewControllers(
                [pages[presenter.getSelectedIndex()]],
                direction: .forward,
                animated: true
            )
        }
    }
}

extension OnboardingViewController: OnboardingViewControllerProtocol {
    func update(with configurePages: [UIViewController]) {
        pages = configurePages
    }
    
    func setupButton(with title: String, backgroundColor: UIColor, textColor: UIColor) {
        continueButton.setTitle(title, for: .normal)
        continueButton.backgroundColor = backgroundColor
        continueButton.setTitleColor(textColor, for: .normal)
    }
    
    func setupButtonTitle(with title: String) {
        continueButton.setTitle(title, for: .normal)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}
