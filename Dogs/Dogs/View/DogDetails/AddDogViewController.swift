//
//  AddDogViewController.swift
//  Dogs
//
//  Created by Inna Markevich on 24.07.22.
//

import Foundation
import UIKit

final class AddDogViewController: UIViewController {

    @IBOutlet weak var save: UIButton!
    private var databaseService = DatabaseService()

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //databaseService.saveData(dog: Dog(breed: "1232", height: 12, weight: 22, description: "wee", images: []))
    }
}
