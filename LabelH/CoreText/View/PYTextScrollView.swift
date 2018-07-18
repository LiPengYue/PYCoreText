//
//  PYTextScrollView.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/11.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

class PYTextScrollView: UIScrollView {
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
        registerEvent()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - properties
    var edgeInsets = UIEdgeInsets.zero
    
    
    // MARK: - func
    /// loadData
    func reloadData(textFrame: PYFrameHander?,imageModelArray: [PYCoreTextImageBaseModel]?) {
        let currentHeight = textFrame?.getAttributedHeight(W: coreTextViewWidth)
        updateTextViewHeightAndScrollSize(height: currentHeight ?? 0)
        coreTextView.reloadData(textFrame: textFrame, imageModelArray: imageModelArray)
    }
    // MARK: network
    
    // MARK: handle views
    
    ///设置
    private func setup() {
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(coreTextView)
        coreTextView.translatesAutoresizingMaskIntoConstraints = false
        coreTextView.layoutTopEqutoSuperView()
        coreTextView.layoutLeftEqutoSuperView()
        coreTextView.layoutRightEqutoSuperView()
        coreTextView.layoutWidthEqutoSuperView()
        heightConstraint = coreTextView.creteHeightConstraint(height: 0)
    }
    
    private func updateTextViewHeightAndScrollSize(height: CGFloat) {
        heightConstraint = coreTextView.updateHeightConstraint(height: height,
                                  constraint: heightConstraint)
        contentSize = CGSize.init(width: frame.width, height: height)
    }
    
    
    // MARK: handle event
    ///事件
    private func registerEvent() {
        
    }
    
    
    // MARK:functions
    // MARK: lazy loads
    private var coreTextView: PYTextView = {
        let textView = PYTextView()
        return textView
    }()
    private lazy var heightConstraint: NSLayoutConstraint = {
        return self.creteHeightConstraint(height: 0)
    }()
    
    private var coreTextViewWidth: CGFloat {
        return frame.width - edgeInsets.left - edgeInsets.right
    }
    
    private var coreTextViewHeight: CGFloat {
        return frame.height - edgeInsets.top - edgeInsets.bottom
    }
    private var coreTextViewX: CGFloat {
        return edgeInsets.left
    }
    private var coreTextViewY: CGFloat {
        return edgeInsets.top
    }
}
