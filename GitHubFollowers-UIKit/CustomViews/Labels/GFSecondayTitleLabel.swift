//
//  GFSecondayTitleLabel.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 8/6/24.
//

import UIKit

class GFSecondayTitleLabel: UILabel {

    init (size: CGFloat){
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: size, weight: .medium)
        configure()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        //light grey
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        //how much to shrink
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
