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
    @IBOutlet weak var createDog: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
       // viewModel.applyData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateData()
        viewModel.applyData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            if let viewController = segue.destination as? DogDetailsViewController {
                viewController.viewModel = DogDetailsViewModel(dog: viewModel.dogs[0])
            }
        }
    }

    @IBAction func changeDatabaseService(_ sender: Any) {
        Settings.shared.activateDatabaseConfiguration(of: .firebase)
    }
}

// MARK: - Binding

private extension DogsListViewController {

    private func setupViewModel() {
        viewModel.snapshot = { [weak self] snapshot in
            self?.dataSource.apply(snapshot)
        }
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

