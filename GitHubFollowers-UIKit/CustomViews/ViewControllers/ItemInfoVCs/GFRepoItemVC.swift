//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 8/7/24.
//

import Foundation

//Subclass generic item view controller
//But add custom code
class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(user: user)
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, count: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }  
}
