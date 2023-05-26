//
//  FindLocationController.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/26/23.
//

import UIKit
import GeneralServices

protocol FindLocationControllerDelegate: AnyObject {
    func didEndEditing(text: String?)
    func didEndLocationSelection(with model: LocationModel)
}

class FindLocationController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: FindLocationControllerDelegate?
    private var locations: [LocationModel] = []
    
    private let titleLabel = UILabel()
    private let locationNameTextField = UITextField()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditing(text: textField.text)
    }
    
    func configure(with locations: [LocationModel]) {
        self.locations = locations
        tableView.reloadData()
    }
    
    private func setupView() {
        view.do {
            $0.backgroundColor = Colors.lightGrey.color
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.text = "Места"
        }
        
        locationNameTextField.do {
            $0.placeholder = "Название..."
            $0.backgroundColor = .systemGray6
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
            view.backgroundColor = .clear
            $0.leftViewMode = .always
            $0.leftView = view
            $0.layer.cornerRadius = 12
            $0.delegate = self
        }
        
        tableView.do {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(locationNameTextField)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        locationNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(locationNameTextField.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension FindLocationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = locations[indexPath.row]
        view.endEditing(true)
        delegate?.didEndLocationSelection(with: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let location = locations[indexPath.row]
        cell.textLabel?.text = location.title
        return cell
    }
}
