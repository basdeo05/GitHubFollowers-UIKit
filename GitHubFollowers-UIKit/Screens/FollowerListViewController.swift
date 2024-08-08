//
//  FollowerListViewController().swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/29/24.
//

import UIKit

protocol FollowerListVCDelegate: class {
    func didRequestFollowers (username: String)
}

class FollowerListViewController: UIViewController {
    
    //if had multiple sections, would just add them here
    //In this example only have one section
    //The DiffableDataSource needs section thats why I have this enum
    enum Section {
        case main
    }
    
    var username: String!
    var followers = [Follower]()
    var filterdFollowers = [Follower]()
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    //Forced unwrape the collection view here because I will use configure funcion to initialize it
    var collectionView: UICollectionView!
    
    //UICollectionViewDifableDataSouce, mainly used when data will change alot
    //Will get animation, and updates for free
    //If data is not changing alot can just use old way
    var dataSource: UICollectionViewDiffableDataSource <Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //Background color should be white or black
    //I want the large title in the nav bar
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView () {
        
        //view.bounds - dont have to constrain collection view if we want it to fill up the whole view
        //no matter what size the view is, just fill up the view
        //let the collection view take up the whole screen
        //tell the collection view it will have three columns and tell it the size of the cells
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(view: view))
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        //Tell the collection view what type of cells it will be using and the id for the cell
        collectionView.register(FollowersCell.self, forCellWithReuseIdentifier: FollowersCell.reuseId)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        
        //stop view from dimming when clicking search bar
        searchController.obscuresBackgroundDuringPresentation = false
        
        //tell the navigation controller this view will have a search controller
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //get the user followers
    func getFollowers(username: String, page: Int) {
        
        showLoadingView()
        
        NetworkManager.shared.getFollowers(username: username, page: page) { [weak self] results in
            
            guard let self = self else {
                return
            }
            
            self.dismissLoadingView()
            switch results {
            case .success(let followers):
                
                //If returned followers is less than 100
                //This means I dont have anymore followers
                //So set flag to false
                //If had 100 follwers I can have more followers so allow for the network call to be ran again
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                
                //set the followers
                self.followers.append(contentsOf: followers)
                
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any follwoers. Go Follow them 😛"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(message: message, view: self.view)
                    }
                    return
                }
                
                //tell the collection view I got new followers, update the view with the new data
                self.updateData(followers: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        
        //Know dealing with follower object, and I know what type of cell to use, and how to configure it
        //Set up the data for the CollectionView
        //Tells the collection view how to convert data to cell
        //Tells the collection view what cell if for what index
        dataSource = UICollectionViewDiffableDataSource <Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCell.reuseId, for: indexPath) as! FollowersCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    //tell the collection view I got new followers, update the view with the new data
    func updateData(followers: [Follower]) {
        
        //create snapshot of the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        //Tell the data source here is the new data
        //Data souce will update collectionview
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true) {
                //Do something after collection view updated
            }
        }
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(username: username) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let user):
                
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    
                    guard let error = error else {
                        self?.presentGFAlertOnMainThread(title: "Succes!", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
                        
                        return
                    }
                    
                    self?.presentGFAlertOnMainThread(title: "Something went wrong", message: "\(error.rawValue)", buttonTitle: "Ok")
                    
                    self?.dismissLoadingView()
                    return
                }
            case .failure(let error):
                
                self.dismissLoadingView()
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(followers: followers)
    }
}

extension FollowerListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            return
        }
        
        isSearching = true
        filterdFollowers = followers.filter({$0.login.lowercased().contains(filter)})
        updateData(followers: filterdFollowers)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filterdFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

extension FollowerListViewController: UICollectionViewDelegate {
    
    //used to determine if at the end of the scrollview
    //once reached the end get more followers if there are
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //how far on the y-axis the user has scrolled on the collectionview
        let yOffset = scrollView.contentOffset.y
        
        //ht height of the entire scrollView
        let contentHeight = scrollView.contentSize.height
        
        //height of the screen
        let scrollViewHeight = scrollView.frame.size.height
        
        if yOffset > contentHeight - scrollViewHeight {
            
            if hasMoreFollowers {
                page += 1
                getFollowers(username: username, page: page)
            }
        }
    }
    
}

extension FollowerListViewController: FollowerListVCDelegate {
    func didRequestFollowers(username: String) {
        //get followers for that user
        self.username = username
        title = username
        followers.removeAll()
        filterdFollowers.removeAll()
        page = 1
        
        //Put the collection view back to the top
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
