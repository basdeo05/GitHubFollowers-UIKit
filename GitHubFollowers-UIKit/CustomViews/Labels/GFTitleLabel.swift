//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/30/24.
//

import UIKit

class GFTitleLabel: UILabel {
    
    
    init (alignment: NSTextAlignment, fontSize: CGFloat){
        super.init(frame: .zero)
        self.textAlignment = alignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        //label means black on white screen and white on light screen
        textColor = .label
        
        //title will just be one long line
        //so if large title we want it to shrink
        adjustsFontSizeToFitWidth = true
        
        //how much to shrink
        minimumScaleFactor = 0.9
        
        //if username is too long, and after 90 percent shrinkage, add ... to the end of the string
        lineBreakMode = .byTruncatingTail
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }

}
