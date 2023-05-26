//
//  MainSections.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/13/23.
//

import UIKit

protocol MainSection {
    func layoutSection() -> NSCollectionLayoutSection
}

struct NewsSection: MainSection {
    func layoutSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 8
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(145)
            ),
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 16, leading: 8, bottom: 16, trailing: 8)
        section.interGroupSpacing = spacing
        
        return section
    }
}

struct ActualsSection: MainSection {
    func layoutSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 8
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(347)
            ),
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = spacing
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(45)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
