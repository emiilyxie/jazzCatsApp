//
//  SnapToCenter.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/24/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class SnapToCenter: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView
        else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)

        let itemSpace = itemSize.width + minimumLineSpacing
        var currentItemIdx = round(collectionView.contentOffset.x / itemSpace)

        // Skip to the next cell, if there is residual scrolling velocity left.
        // This helps to prevent glitches
        let vX = velocity.x
        if vX > 0 {
            currentItemIdx += 1
        } else if vX < 0 {
            currentItemIdx -= 1
        }
        
        let nearestPageOffset = currentItemIdx * itemSpace - collectionView.contentInset.left
        return CGPoint(x: nearestPageOffset, y: parent.y)
    }

}
