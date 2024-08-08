//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/30/24.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    
    func presentSafariVC (url: URL){
        let safarVC = SFSafariViewController(url: url)
        safarVC.preferredControlTintColor = .systemGreen
        present(safarVC, animated: true)
    }
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView (){
        
        //view.bound frame means full up the entire screen
        //Dont need to set constraints on it
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        
        //want to animate backgrount to a higher alpha, that is why its being set to 0 initially
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        //Dont need to set height and width because using style large
        NSLayoutConstraint.activate([
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView () {
        
        DispatchQueue.main.async {
            //removing subview
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    
    func showEmptyStateView (message: String, view: UIView){
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
