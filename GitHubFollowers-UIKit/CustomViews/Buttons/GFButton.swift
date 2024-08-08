//
//  GFButton.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/29/24.
//

import UIKit

class GFButton: UIButton {
    
    override init(frame: CGRect) {
        //Call default init method
        super.init(frame: frame)
        configure()
    }
    
    init (backgroundColor: UIColor, title: String){
        
        //Know going to configure the frame with autolayout
        //So we can initlaize with a frame of zero
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    
    //This init needs to be here for storyboards
    //Since not using storyboards, can leave default behavior provided by Xcode
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure () {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        
        //Using preferred font to handle user increaseing font size
        //this functionality is automatically handled by apple
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        
        //Auto layout
        //Saying use auto layout, going to use programtic auto layout
        translatesAutoresizingMaskIntoConstraints = false
    }
}
