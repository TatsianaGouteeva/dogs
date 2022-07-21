//
//  DogsListViewController.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 18.07.22.
//

import UIKit

final class DogsListViewController: UIViewController {

    private typealias DataSource = UITableViewDiffableDataSource<ListSection, ListItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>
    private lazy var dataSource: DataSource = makeDataSource()
    private var viewModel: DogsListViewModel = DogsListViewModel()

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        viewModel.applyData()
    }
}

// MARK: - Binding

private extension DogsListViewController {

    func setupViewModel() {
        viewModel.snapshot = { [weak self] snapshot in
            self?.dataSource.apply(snapshot)
        }

        viewModel.didSelectDog = { [weak self] dog in
            self?.showDetailDogInfo(for: dog)
        }
    }

    func showDetailDogInfo(for dog: Dog) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "DogDetailsViewController") as! DogDetailsViewController
        destVC.viewModel = DogDetailsViewModel(dog: dog)
        navigationController?.pushViewController(destVC, animated: true)
    }
}

extension DogsListViewController {

    fileprivate func setupTableView(){
        tableView.register(UINib(nibName: "DogsListTableViewCell", bundle: nil), forCellReuseIdentifier: DogsListTableViewCell.reuseIdentifier)
    }
}

// MARK: - DataSource

private extension DogsListViewController {

    private func makeDataSource() -> DataSource {

        let dataSource = UITableViewDiffableDataSource<ListSection, ListItem>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: ListItem) -> UITableViewCell? in

            let cell = tableView.dequeueReusableCell(
                withIdentifier: DogsListTableViewCell.reuseIdentifier,
                for: indexPath) as! DogsListTableViewCell
            cell.breedLabel.text = item.breed
            return cell
        }
        return dataSource
    }
}

extension DogsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.cellSelected(for: indexPath.row)
    }
}

enum ListSection: CaseIterable {
    case list
}

struct ListItem: Hashable {
    var imageName: String
    var breed: String
}

