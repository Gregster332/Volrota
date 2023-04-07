//
//  OrganizationsCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/7/23.
//

import DropDown

struct OrganizationsCellProps {
    let items: [String]
    let tag: Int
    let chooseOrganizationCompletion: ((Int) -> Void)?
}

class OrganizationsCell: UITableViewCell {
    
    private var chooseOrganizationCompletion: ((Int) -> Void)?
    
    private let textField = UITextField()
    private let dropDown = DropDown()
    private let dropDownMenuButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func render(with props: OrganizationsCellProps) {
        dropDown.dataSource = props.items
        textField.tag = props.tag
        chooseOrganizationCompletion = props.chooseOrganizationCompletion
    }
}

private extension OrganizationsCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        dropDownMenuButton.do {
            $0.setImage(UIImage(systemName: "chevron.down.circle.fill")!, for: .normal)
            $0.addTarget(self, action: #selector(handleOpenDropDown), for: .touchUpInside)
        }
        
        textField.do {
            $0.textColor = .black
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemBlue.cgColor
            $0.layer.cornerRadius = 10
            $0.placeholder = "type..."
            $0.setLeftPaddingPoints(12)
            $0.isEnabled = false
        }
        
        dropDown.do {
            $0.anchorView = textField
            $0.selectionAction = { [weak self] index, item in
                self?.textField.text = item
                self?.chooseOrganizationCompletion?(index)
            }
            $0.dismissMode = .onTap
            $0.direction = .bottom
            $0.bottomOffset = CGPoint(x: 0, y: 48)
            $0.dimmedBackgroundColor = .clear
            $0.backgroundColor = .white
            $0.selectionBackgroundColor = .clear
            $0.cornerRadius = 12
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(textField)
        contentView.addSubview(dropDownMenuButton)
        
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.width.equalTo(contentView.frame.size.width - 36)
            $0.verticalEdges.equalToSuperview().inset(4)
        }
        
        dropDownMenuButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    @objc func handleOpenDropDown() {
        dropDown.show()
    }
}
