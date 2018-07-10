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
    func reloadData(textFrame: PYFrameHander,imageModelArray: [PYCoreTextImageBaseModel]) {
        self.textFrame = textFrame
        coreTextView.imageModelArray = imageModelArray
    }
    var textFrame: PYFrameHander? {
        didSet{
            if let textFrame = textFrame {
                coreTextView.textFrame = textFrame
                let height = textFrame.attributedMaxSize.height
                updateTextViewHeight(height: height)
            }
        }
    }
    
    
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

        coreTextView.addConstraints([heightConstraints])
        contentView.addConstraints([top,left,right,bottom])
    }
    private lazy var heightConstraints: NSLayoutConstraint = {
        return self.creteTextViewHeightConstraint(height: 0)
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
}


// MARK: - PYcoreText delegate
extension PYCoreTextTableViewCell {
  
    
}
