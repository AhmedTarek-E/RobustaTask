//
//  UIViewController+Extensions.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showError(error: String) {
        let alert = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default)
        )
        present(alert, animated: true)
    }
}
