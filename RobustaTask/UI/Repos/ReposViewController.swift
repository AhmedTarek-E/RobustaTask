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
    
    private var repositories: [MiniRepo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //TODO
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
    }
}

extension ReposViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier, for: indexPath)
        
        return cell
    }
    
}
