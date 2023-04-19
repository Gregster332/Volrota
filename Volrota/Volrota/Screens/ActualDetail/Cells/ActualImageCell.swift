//
//  ActualImageCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/12/23.
//

import Kingfisher

class ActualImageCell: UITableViewCell {
    
    private let actualImageView = UIImageView()
    
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
    
    func render(with imageUrl: String) {
        actualImageView.kf.setImage(with: URL(string: imageUrl))
    }
}


private extension ActualImageCell {
    
    func setupView() {
        
        self.do {
            $0.selectionStyle = .none
        }
        
        contentView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
        }
        
        actualImageView.do {
            $0.kf.indicatorType = .activity
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(actualImageView)
        
        actualImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
}


