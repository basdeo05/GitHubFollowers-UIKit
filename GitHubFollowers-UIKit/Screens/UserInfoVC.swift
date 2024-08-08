//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 8/6/24.
//

import UIKit
//To use safari browser, need to import
import SafariServices

protocol UserInfoVCDelegate: class {
    func didTapGitHubProfile(user: User)
    func didTapGetFollowers(user: User)
}

class UserInfoVC: UIViewController {

    var username: String!
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(alignment: .center)
    var itemViews = [UIView]()
    
    weak var delegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    
    func configureViewController () {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo () {
        NetworkManager.shared.getUserInfo(username: username) { [weak self] results in
            
            guard let self = self else {
                return
            }
            
            switch results {
            case .success(let userInformation):
                
                DispatchQueue.main.async {
                    self.configureUIElements(user: userInformation)
                }
                
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: failure.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements (user: User){
        
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemsVC(user: user)
        followerItemVC.delegate = self
        
        add(childVC: GFUserInfoHeaderVC(user: user), containerView: headerView)
        add(childVC: repoItemVC, containerView: itemViewOne)
        add(childVC: followerItemVC, containerView: itemViewTwo)
        dateLabel.text = "GitHub Since \(user.createdAt.convertToDisplayFormate())"
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            //I can add repeating constraints in here as well
        }
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
//    func layoutUI() {
//        view.addSubview(headerView)
//        view.addSubview(itemViewOne)
//        view.addSubview(itemViewTwo)
//        
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
//        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
//        
//        let padding: CGFloat = 20
//        NSLayoutConstraint.activate([
//        
//            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 180),
//            
//            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
//            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
//            
//            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
//            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
//            
//        
//        ])
//    }
    
    //This is how you add a view controller to a view
    func add(childVC: UIViewController, containerView: UIView){
        
        //telling the current view controller this view controller will be a child of yours
        addChild(childVC)
        
        //add the view to the container
        containerView.addSubview(childVC.view)
        
        //let the child talke up the whole frame
        childVC.view.frame = containerView.bounds
        
        //mandatory
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGitHubProfile(user: User) {
        //show safari view controller
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(url: url)
    }
    
    func didTapGetFollowers(user: User) {
        
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This user has no followers", buttonTitle: "Ok")
            return
        }
        //tell follower list screen the new user
        delegate.didRequestFollowers(username: user.login)
        
        //dismiss
        dismissVC()
    }
}
