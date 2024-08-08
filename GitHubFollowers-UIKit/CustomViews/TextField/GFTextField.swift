//
//  GHTextField.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/29/24.
//

import UIKit

class GFTextField: UITextField {

    //Two required init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure () {
        translatesAutoresizingMaskIntoConstraints = false
        
        //border
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        
        //text
        //label = white on dark mode and black on light mode
        textColor = .label
        //blinking cursor
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        //if a user has large username, the font will shrink to make sure it fits
        adjustsFontSizeToFitWidth = true
        //want the font to shrink, but dont go less than 12
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        //dont want to autocorrent usernames because they cant be anything
        autocorrectionType = .no
        returnKeyType = .search
        
        placeholder = "Enter a username"
    }
}
