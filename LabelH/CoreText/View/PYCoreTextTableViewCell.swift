//
//  PYCoreTextTableViewCell.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/10.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

class PYCoreTextTableViewCell: UITableViewCell {

    // MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - properties
    func reloadData(cellHeight: CGFloat? = -1, textFrame: PYFrameHander?,imageModelArray: [PYCoreTextImageBaseModel]?) {
        var h = cellHeight ?? -1
        h = h <= 0 ? (textFrame?.getAttributedHeight(W: self.frame.width) ?? 0) : h
//        updateTextViewHeight(height: h)
        self.textFrame = textFrame
        self.imageModelArray = imageModelArray
//        coreTextView.reloadData(textFrame: textFrame, imageModelArray: imageModelArray)
        scrollView.reloadData(textFrame: textFrame, imageModelArray: imageModelArray)
    }
    var imageModelArray: [PYCoreTextImageBaseModel]?
    var textFrame: PYFrameHander?
    
    // MARK: - func
    // MARK: handle views
    private func setup() {
        contentView.addSubview(coreTextView)
        coreTextView.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint.init(item: coreTextView,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: contentView,
                                attribute: .left,
                                multiplier: 1,
                                constant: 0)
        let right = NSLayoutConstraint.init(item: coreTextView,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: contentView,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: 0)
        let top = NSLayoutConstraint.init(item: coreTextView,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: contentView,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 0)
        let bottom = NSLayoutConstraint.init(item: coreTextView,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: contentView,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 0)
        top.isActive = true
        bottom.isActive = true
        left.isActive = true
        right.isActive = true
        
        coreTextView.addConstraints([heightConstraints])
        contentView.addConstraints([top,left,right,bottom])
    }
    private lazy var heightConstraints: NSLayoutConstraint = {
        return self.creteTextViewHeightConstraint(height: 330)
    }()
    

    private func updateTextViewHeight(height: CGFloat) {
        coreTextView.removeConstraint(heightConstraints)
        heightConstraints = creteTextViewHeightConstraint(height: height)
        coreTextView.addConstraint(heightConstraints)
        coreTextView.updateConstraints()
    }
    
    private func creteTextViewHeightConstraint(height: CGFloat) -> NSLayoutConstraint {
        let height = NSLayoutConstraint.init(item: coreTextView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: height)
        height.isActive = true
        return height
    }
    // MARK: handle event
    
    // MARK:functions
    
    // MARK:life cycles
    
    // MARK: lazy loads
    private lazy var coreTextView: PYTextView = {
        let textView = PYTextView()
        textView.backgroundColor = UIColor.randomColor
        return textView
    }()
    let scrollView = PYTextScrollView()
}


// MARK: - PYcoreText delegate
extension PYCoreTextTableViewCell {
  
    
}
