//
//  EmployeeTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Thomas Chin on 4/25/22.
//

import Foundation
import UIKit

class EmployeeTableViewCell : UITableViewCell {
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    let teamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        
        return containerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setupViews() {
        self.contentView.addSubview(profileImageView)
        self.containerView.addSubview(nameLabel)
        self.containerView.addSubview(teamLabel)
        self.containerView.addSubview(emailLabel)
        self.contentView.addSubview(containerView)
        
        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:80).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant:10).isActive = true
        
        teamLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        teamLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        teamLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        
        emailLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo:self.teamLabel.bottomAnchor, constant:20).isActive = true
    }
    
}
