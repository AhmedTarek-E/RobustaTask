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
        vc.repoId = repoId
        return vc
    }
    
    private var repoId: Int!
    
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
    
    private let viewModel = RepoDetailsViewModel(
        repoDetailsUseCase: RepoDetailsUseCaseImp(
            service: GithubRepositoriesServiceImp()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.state.subscribe(observerQueue: .main) { [weak self] value in
            self?.renderState(state: value)
        }
        viewModel.getRepoDetails(repoId: repoId)
        setupView()
    }
    
    func setupView() {
        navigationItem.title = "Repo Details"
        ownerImageView.layer.cornerRadius = 8
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func renderState(state: RepoDetailsState) {
        switch state.details {
        case .initial:
            hideIndicator()
            hideContainer()
            
        case .loading:
            showIndicator()
            hideContainer()
            
        case .failure(error: let error):
            hideIndicator()
            hideContainer()
            showError(error: error)
            
        case .success(data: let data):
            hideIndicator()
            showContainer()
            display(details: data)
        }
    }
    
    func hideContainer() {
        containerView.isHidden = true
    }

    func showContainer() {
        containerView.isHidden = false
    }
    
    func display(details: RepoDetails) {
        nameLabel.attributedText = details.attributedName
        dateLabel.text = details.getPrettyDate()
        languageLabel.text = "Language: \(details.language)"
        ownerImageView.loadImage(url: details.owner.avatar)
        descriptionLabel.text = details.basicInfo.description
        defaultBranchLabel.text = details.defaultBranch
        sizeLabel.text = details.getPrettySize()
        watchersLabel.text = "\(details.watchersCount)"
        forksLabel.text = "\(details.forksCount)"
        openIssuesLabel.text = "\(details.openIssuesCount)"
        licenseLabel.text = details.license
    }
}

extension RepoDetails {
    var attributedName: NSAttributedString {
        let string = NSMutableAttributedString()
        string.append(ownerName)
        string.append(NSAttributedString(string: "/"))
        string.append(repoName)
        return string
    }
    
    private var ownerName: NSAttributedString {
        let string = NSMutableAttributedString(string: owner.name)
        string.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 20),
            range: NSRange(0..<string.length)
        )
        return string
    }
    
    private var repoName: NSAttributedString {
        let string = NSMutableAttributedString(string: basicInfo.name)
        string.addAttribute(
            .font,
            value: UIFont.boldSystemFont(ofSize: 20),
            range: NSRange(0..<string.length)
        )
        return string
    }
    
    func getPrettyDate() -> String {
        let now = Date.now
        let passed = now.timeIntervalSince1970 -  createdAt.timeIntervalSince1970
        if passed > 60*60*24*30 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            return formatter.string(from: createdAt)
        } else {
            let formatter = RelativeDateTimeFormatter()
            return formatter.localizedString(fromTimeInterval: passed)
        }
    }
    
    func getPrettySize() -> String {
        let formatter = ByteCountFormatter()
        return formatter.string(fromByteCount: Int64(size))
    }
}
