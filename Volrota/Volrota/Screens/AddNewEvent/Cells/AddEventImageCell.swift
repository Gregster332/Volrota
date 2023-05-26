//
//  AddEventImageCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/25/23.
//

import UIKit

protocol AddEventImageCellProtocol: AnyObject {
    func didTapOnSetImage()
}

class AddEventImageCell: UICollectionViewCell {
    
    private weak var delegate: AddEventImageCellProtocol?
    
    private let imageView = UIImageView()
    private let setImageButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func render(cellDelegate delegate: AddEventImageCellProtocol, image: UIImage?) {
        self.delegate = delegate
        self.imageView.image = image ?? Images.imagePlaceholder.image
    }
}

private extension AddEventImageCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        imageView.do {
            $0.image = Images.bred.image
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 75
            $0.clipsToBounds = true
        }
        
        setImageButton.do {
            $0.setTitle(Strings.AddNewEvent.chooseImage, for: .normal)
            $0.setTitleColor(Colors.accentColor.color, for: .normal)
            $0.backgroundColor = .clear
            $0.addTarget(self, action: #selector(handleTapOnSelectImage), for: .touchUpInside)
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(setImageButton)
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(150)
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        setImageButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    @objc func handleTapOnSelectImage() {
        delegate?.didTapOnSetImage()
    }
}
