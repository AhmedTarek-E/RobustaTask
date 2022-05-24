//
//  RepoDetailsViewController.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import UIKit

class RepoDetailsViewController: UIViewController {
    
    static func create(repoId: Int) -> RepoDetailsViewController {
        let vc = RepoDetailsViewController(
            nibName: String(describing: self),
            bundle: Bundle(for: self)
        )
        return vc
    }
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var defaultBranchLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var openIssuesLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var licenseLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = RepoDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        navigationItem.title = "Repo Details"
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

}
