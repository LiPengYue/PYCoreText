//
//  UIViewLayout+Extension.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/12.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func layoutTopEqutoSuperView() -> NSLayoutConstraint {
        let top = NSLayoutConstraint.init(item: self,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: superview,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 0)
        top.isActive = true
        superview?.addConstraint(top)
        return top
    }
    
    @discardableResult
    func layoutLeftEqutoSuperView() -> NSLayoutConstraint {
        let left = NSLayoutConstraint.init(item: self,
                                           attribute: .left,
                                           relatedBy: .equal,
                                           toItem: superview,
                                           attribute: .left,
                                           multiplier: 1,
                                           constant: 0)
        left.isActive = true
        superview?.addConstraint(left)
        return left
    }
    
    @discardableResult
    func layoutRightEqutoSuperView() -> NSLayoutConstraint {
        let right = NSLayoutConstraint.init(item: self,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: 0)
        right.isActive = true
        superview?.addConstraint(right)
        return right
    }
    
    @discardableResult
    func layoutSuperViewEdges() -> (top: NSLayoutConstraint,bottom: NSLayoutConstraint,left:NSLayoutConstraint, right: NSLayoutConstraint) {
        let left = NSLayoutConstraint.init(item: self,
                                           attribute: .left,
                                           relatedBy: .equal,
                                           toItem: superview,
                                           attribute: .left,
                                           multiplier: 1,
                                           constant: 0)
        let right = NSLayoutConstraint.init(item: self,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: 0)
        let top = NSLayoutConstraint.init(item: self,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: superview,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 0)
        let bottom = NSLayoutConstraint.init(item: self,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: superview,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 0)
        top.isActive = true
        bottom.isActive = true
        left.isActive = true
        right.isActive = true
        superview?.addConstraints([top,left,right,bottom])
        return (top,bottom,left,right)
    }
    
    @discardableResult
    func updateHeightConstraint(height: CGFloat,constraint: NSLayoutConstraint) -> NSLayoutConstraint {
        let newConstraint = creteHeightConstraint(height: height)
        removeConstraint(constraint)
        addConstraint(newConstraint)
        updateConstraints()
        layoutIfNeeded()
        return newConstraint
    }
    
    @discardableResult
    func creteHeightConstraint(height: CGFloat) -> NSLayoutConstraint {
        let height = NSLayoutConstraint.init(item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: height)
        height.isActive = true
        return height
    }
    
    // MARK: - w : h
    @discardableResult
    func layoutHeightEqutoSuperView(offset: CGFloat? = 0) -> NSLayoutConstraint {
        
        let height = NSLayoutConstraint.init(item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: superview,
                                             attribute: .height,
                                             multiplier: 1,
                                             constant: offset ?? 0)
        height.isActive = true
        superview?.addConstraint(height)
        return height
    }
    
    @discardableResult
    func layoutWidthEqutoSuperView(offset: CGFloat? = 0) -> NSLayoutConstraint {
        
        let width = NSLayoutConstraint.init(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .width,
                                            multiplier: 1,
                                            constant: offset ?? 0)
        
        width.isActive = true
        superview?.addConstraint(width)
        return width
    }
}
