//
//  GFFollowerItemsVC.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 8/7/24.
//

import Foundation

class GFFollowerItemsVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(user: user)
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, count: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
