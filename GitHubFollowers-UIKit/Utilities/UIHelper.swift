//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/31/24.
//

import UIKit

struct UIHelper {
    
    //Tell CollectionView I want three columns with spacing and padding
    static func createThreeColumnFlowLayout(view: UIView) -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding: CGFloat = 12 //left and right sides
        let minimumItemSpacing: CGFloat = 10 //spacing between each cell
        
        //avaiable width - the two side padding minus the the two cell spacing
        let avaibleWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = avaibleWidth / 3
        
        //create the flow layout
        let flowLayout = UICollectionViewFlowLayout()
        
        //padding for each item
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        //item size
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
