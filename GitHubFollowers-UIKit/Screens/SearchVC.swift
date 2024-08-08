//
//  ViewController.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 5/29/24.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //tap anywhere on the screen to dismiss the keyboard
    func createDismissKeyboardTapGesture() {
        
        //here we are using tap gestures
        //There are other gestures: UIPanGesture, hover, pinch, swipe, etc
        //Target is this view
        //seletor is the action
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        //have to put the tap gesture on any view
        //in our case we want the entire view
        //an example is you can put the gesture on the logo image
        //logoImageView.addGestureRecognizer(tap)
        
        view.addGestureRecognizer(tap)
    }
    
    //Triggerd when user slects search in keyboard or the get followers button
    @objc func pushFollowerListVC () {
        
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😛.", buttonTitle: "Ok")
            return
        }
        
        let followersListVC = FollowerListViewController()
        followersListVC.username = usernameTextField.text
        followersListVC.title = usernameTextField.text
        navigationController?.pushViewController(followersListVC, animated: true)
    }
    
    
    
    
    func configureLogoImageView() {
        
        //Grabbing ui element and dropping it onto the storyboard
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        //constraints
        //Genearlly want to have 4 constraints per object
        //usually its height, width, x coordinate, y coordinate
        NSLayoutConstraint.activate([
            
            //I know will be at the top
            //Pinning to the top
            //constraint(equalTo, constant) - Where are you pinning to , and constant away from that anchor
            //safeAreaLayoutGuide - for notches
            //top anchor, where the view will be on the y coordinate
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            //center the logo on the x coordinate
            //dont need constant
            //center this in the view
            //know where the element will be on the x coordinate
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //I know will be a square
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            //To create width and of the textfield gonna pin it to the left and right of the screen
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //for trailing, need to do negative constant
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        //add the target button action to the button
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])        
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

