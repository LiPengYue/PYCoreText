//
//  UIViewLayout+Extension.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/12.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: - top
    @discardableResult
    func layoutTopEqutoSuperView() -> NSLayoutConstraint {
        return layoutTopToView(toView: superview!, offset:  0)
    }
    @discardableResult
    func layoutTopToView(toView: UIView, offset: CGFloat) -> NSLayoutConstraint {
        let top = NSLayoutConstraint.init(item: self,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: toView,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 0)
        top.isActive = true
        toView.addConstraint(top)
        return top
    }
    
    // MARK: - left
    @discardableResult
    func layoutLeftEqutoSuperView() -> NSLayoutConstraint {
        return layoutLeftToView(view: superview!, offset: 0)
    }
    
    @discardableResult
    func layoutLeftToView(view: UIView,offset: CGFloat) -> NSLayoutConstraint {
        let left = NSLayoutConstraint.init(item: self,
                                           attribute: .left,
                                           relatedBy: .equal,
                                           toItem: view,
                                           attribute: .left,
                                           multiplier: 1,
                                           constant: offset)
        left.isActive = true
        view.addConstraint(left)
        return left
    }
    
    
    // MARK: - right
    @discardableResult
    func layoutRightEqutoSuperView() -> NSLayoutConstraint {
        return layoutRightToView(toView: superview!, offsest: 0)
    }
    
    @discardableResult
    func layoutRightToView(toView: UIView, offsest: CGFloat) -> NSLayoutConstraint {
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
    
    // MARK: - edgs
    @discardableResult
    func layoutSuperViewEdges() -> (top: NSLayoutConstraint,bottom: NSLayoutConstraint,left:NSLayoutConstraint, right: NSLayoutConstraint) {
       return layoutEdges(toView: superview!)
    }
    @discardableResult
    func layoutEdges(toView: UIView) -> (top: NSLayoutConstraint,bottom: NSLayoutConstraint,left:NSLayoutConstraint, right: NSLayoutConstraint) {
        let left = NSLayoutConstraint.init(item: self,
                                           attribute: .left,
                                           relatedBy: .equal,
                                           toItem: toView,
                                           attribute: .left,
                                           multiplier: 1,
                                           constant: 0)
        let right = NSLayoutConstraint.init(item: self,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: toView,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: 0)
        let top = NSLayoutConstraint.init(item: self,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: toView,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 0)
        let bottom = NSLayoutConstraint.init(item: self,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: toView,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 0)
        top.isActive = true
        bottom.isActive = true
        left.isActive = true
        right.isActive = true
        toView.addConstraints([top,left,right,bottom])
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
    
    @discardableResult
    func layoutSelfTopEqutoViewBottom(toView: UIView,offset: CGFloat) -> NSLayoutConstraint {
        let top = NSLayoutConstraint.init(item: self,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: toView,
                                          attribute: .bottom,
                                          multiplier: 1,
                                          constant: offset)
        return top
    }


}
