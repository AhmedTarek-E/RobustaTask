//
//  ImagesLoader.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import UIKit

extension UIImageView {
    func loadImage(url: String) {
        //TODO show placeholder
        guard let url = URL(string: url) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self?.setUIImage(image: image)
                }
            }
        }
    }
    
    private func setUIImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
    }
}
