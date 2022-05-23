//
//  ReposViewController.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import UIKit

class ReposViewController: UIViewController {
    
    static func create() -> ReposViewController {
        let vc = ReposViewController(
            nibName: String(describing: self),
            bundle: Bundle(for: self)
        )
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //TODO
    }

}
