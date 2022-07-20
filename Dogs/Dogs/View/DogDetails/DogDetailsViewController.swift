//
//  DogDetailsViewController.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 7/17/22.
//

import UIKit

final class DogDetailsViewController: UIViewController {

    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>
    private var currentSectionType: SectionType = .imageList

    @IBOutlet weak var sectionTypeSwitcher: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = createLayout()
        }
    }
    
    private lazy var dataSource: DataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applySnapshot()
    }

    @IBAction func showCollage(_ sender: Any) {
        if currentSectionType == .imageList {
            currentSectionType = .collage
            sectionTypeSwitcher.title = "Hide collage"
        } else {
            currentSectionType = .imageList
            sectionTypeSwitcher.title = "Collage"
        }
        applySnapshot()
    }
}

// MARK: DataSource

private extension DogDetailsViewController {
    
    private func makeDataSource() -> DataSource {
      let dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
          switch item {
          case .image(let imageName):
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ImageDogCollectionViewCell",
                for: indexPath) as? ImageDogCollectionViewCell
              
              guard let cell = cell else { return UICollectionViewCell() }
              
              cell.configure(image: imageName)
              return cell
          case .dog(let dogDescriptionModel):
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DescriptionDogCollectionViewCell",
                for: indexPath) as? DescriptionDogCollectionViewCell
              
              guard let cell = cell else { return UICollectionViewCell() }
              
              cell.configure(model: dogDescriptionModel)
              return cell
          }
      })
      return dataSource
    }

    func applySnapshot() {

        var snapshot = Snapshot()
        switch currentSectionType {
        case .collage:
            snapshot.appendSections([.collage])
            snapshot.appendItems([.image("dog1"), .image("dog2"), .image("dog3"), .image("dog4")])
        case .imageList:
            snapshot.appendSections([.imageList])
            snapshot.appendItems([.image("dog1"), .image("dog2"), .image("dog3"), .image("dog4")])
        case .description:
             break
        }

        snapshot.appendSections([.description])
        snapshot.appendItems([.dog(.init(breed: "Akita", height: "28 inches", weight: "80 pounds", description: "Akita is muscular, double-coated dogs of ancient Japanese lineage famous for her dignity, courage, and loyalty. In her native land, she's venerated as family protectors and symbols of good health, happiness, and long life."))])
        dataSource.apply(snapshot)
    }
}

// MARK: UICollectionViewLayout

private extension DogDetailsViewController {
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _) in
            guard let self = self else { return nil }

            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let section = self.makeSection(for: sectionType)

            section.contentInsets = self.makeContentInset(for: sectionType)
            return section
        }
    }

    func makeSection(for sectionType: SectionType) -> NSCollectionLayoutSection {

        switch sectionType {
        case .collage, .description:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = makeGroup(item: item, for: sectionType)
            return NSCollectionLayoutSection(group: group)
        case .imageList:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = makeGroup(item: item, for: sectionType)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 40
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
            return section
        }
    }

    func makeContentInset(for sectionType: SectionType) -> NSDirectionalEdgeInsets {
        switch sectionType {
        case .collage, .description:
             return NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        case .imageList:
            return NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        }
    }
    
    func makeGroup(item: NSCollectionLayoutItem, for sectionType: SectionType) -> NSCollectionLayoutGroup {
        var groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2)
        )
        switch sectionType {
        case .collage:
            return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionType.columnCount)
        case  .imageList:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.43))
            return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionType.columnCount)
        case .description:
            return NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: sectionType.columnCount)
        }
    }
}

// MARK: SectionType

private extension DogDetailsViewController {
    
    enum SectionType: Int, CaseIterable {
        case collage
        case imageList
        case description
        
        var columnCount: Int {
            switch self {
            case .collage:
                return 3
            case .imageList:
                return 1
            case .description:
                return 1
            }
        }
    }
    
    enum Item: Hashable {
        case image(String)
        case dog(DogDescription)
    }
}
