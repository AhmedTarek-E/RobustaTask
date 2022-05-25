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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let viewModel = ReposViewModel(
        reposUseCase: ReposUseCaseImp(
            service: GithubRepositoriesServiceImp(),
            databaseService: DatabaseServiceImp(
                managedContext: AppDelegate.shared.persistentContainer.viewContext
            )
        )
    )
    
    private var repositories: [MiniRepo] = []
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.state.subscribe(observerQueue: .main) { [weak self] value in
            self?.renderState(state: value)
        }
        
        viewModel.getRepos(searchKey: "", page: 1)
        
        setupView()
    }
    
    @IBAction func retryAction(_ sender: Any) {
        viewModel.getRepos(searchKey: searchController.searchBar.text ?? "", page: 1)
    }
    
    
    func setupView() {
        navigationItem.title = "Repositories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Repositories"
    }
    
    func renderState(state: ReposState) {
        switch state.repos {
        case .initial:
            hideIndicator()
            hideRetryButton()
            
        case .loading:
            showIndicator()
            hideRetryButton()
            
        case .failure(error: let error):
            hideIndicator()
            showError(error: error)
            showRetryButton()
            
            
        case .success(data: let data):
            hideIndicator()
            hideRetryButton()
            displayRepos(repos: data)
        }
    }
    
    func hideRetryButton() {
        retryButton.isHidden = true
    }
    
    func showRetryButton() {
        if repositories.isEmpty {
            retryButton.isHidden = false
        } else {
            retryButton.isHidden = true
        }
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func displayRepos(repos: [MiniRepo]) {
        repositories.append(contentsOf: repos)
//        let start = repositories.count - repos.count
//        let indices = (start..<repos.count).map { item in
//            return IndexPath(row: item, section: 0)
//        }
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

}

extension ReposViewController {
    func setupTableView() {
        tableView.register(
            UINib(
                nibName: String(describing: RepoCell.self),
                bundle: Bundle.init(for: RepoCell.self)
            ),
            forCellReuseIdentifier: RepoCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
    }
}

extension ReposViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier, for: indexPath) as! RepoCell
        cell.delegate = self
        cell.bind(repo: repositories[indexPath.row])
        return cell
    }
    
}

extension ReposViewController: RepoCellDelegate {
    func repoCellDidTap(_ cell: RepoCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let repo = repositories[indexPath.row]
            let vc = RepoDetailsViewController.create(repoId: repo.basicInfo.id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ReposViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] timer in
            guard let self = self else { return }
            
            self.repositories = []
            self.tableView.reloadData()
            self.viewModel.getRepos(searchKey: text, page: 1)
        })
    }
}

extension ReposViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row >= repositories.count - 4 {
                viewModel.paginate()
                return
            }
        }
    }
}
