//
//  RepoCell.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 23/05/2022.
//

import UIKit

protocol RepoCellDelegate: AnyObject {
    func repoCellDidTap(_ cell: RepoCell)
}

class RepoCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    weak var delegate: RepoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(didTapCellGestureHandler)
            )
        )
    }
    
    @objc private func didTapCellGestureHandler() {
        delegate?.repoCellDidTap(self)
    }
    
    func bind(repo: MiniRepo) {
        nameLabel.attributedText = repo.attributedName
        descriptionLabel.text = repo.basicInfo.description
        userImageView.loadImage(url: repo.owner.avatar)
    }
    
}

extension MiniRepo {
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
}
