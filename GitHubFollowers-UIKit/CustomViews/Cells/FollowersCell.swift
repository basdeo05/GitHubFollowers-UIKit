//
//  FollowersCell.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/31/24.
//

import UIKit

class FollowersCell: UICollectionViewCell {
    
    //Each cell needs an id
    static let reuseId = "FollowerCell"
    
    //Cell will have an image for the avatar
    let avatarImageView = GFAvatarImageView(frame: .zero)
    //Cell will have a lable for the user's name
    let usernameLabel = GFTitleLabel(alignment: .center, fontSize: 16)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Will be used by the collection view to set the cell label and image
    func set(follower: Follower){
        usernameLabel.text = follower.login
        avatarImageView.downloadImage(string: follower.avatarUrl)
    }
    
    //Constraints for the image and label
    //dont use view.leadinganchor here jsut use name
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            //Need to fix hard coding
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        
        ])
    }
}
