//
//  ProfileViewController.swift
//  Dogs
//
//  Created by Tatsiana Gouteeva on 18.07.22.
//

import UIKit

final class ProfileViewController: UIViewController {

    var settings = Settings.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func switchDataBase(_ sender: Any) {
        settings.activeDatabaseConfiguration = .firebase
    }
}
