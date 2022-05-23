//
//  WindowManager.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import Foundation
import UIKit

enum WindowManager {
    static func configure() {
        window.makeKeyAndVisible()
        //TODO: set the root
        window.rootViewController = UINavigationController()
    }
}

extension WindowManager {
    static var window: UIWindow {
        if let window = AppDelegate.shared.window {
            return window
        } else {
            AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
            return AppDelegate.shared.window!
        }
    }
}
