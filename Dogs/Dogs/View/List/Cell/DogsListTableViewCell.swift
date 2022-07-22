//
//  DogsListTableViewCell.swift
//  Dogs
//
//  Created by Inna Markevich on 21.07.22.
//

import UIKit

final class DogsListTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DogsListTableViewCellIdentifier"

    @IBOutlet private weak var dogImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
}