//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/30/24.
//

import UIKit

class GFBodyLabel: UILabel {

    init (alignment: NSTextAlignment){
        super.init(frame: .zero)
        self.textAlignment = alignment
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
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        //how much to shrink
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
