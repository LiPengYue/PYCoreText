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
    var imageModelArray: [PYCoreTextImageBaseModel]?
    /// loadData
    func reloadData(textFrame: PYFrameHander?,imageModelArray: [PYCoreTextImageBaseModel]?) {
        let currentHeight = textFrame?.getAttributedHeight(W: coreTextViewWidth)
        updateTextViewHeightAndScrollSize(height: currentHeight ?? 0)
        coreTextView.reloadData(textFrame: textFrame, imageModelArray: imageModelArray)
    }
    
    
    ///
    ///
    /// - Parameter textFrame:
    func addFrameHandler(textFrame: PYFrameHander?) {
        
    }
    // MARK: network
    
    // MARK: handle views
    
    ///设置
    private func setup() {
        
    }
    
    private func setupLayout(referenceView: UIView,coreTextView: PYTextView, height: CGFloat) {
        addSubview(coreTextView)
        coreTextView.translatesAutoresizingMaskIntoConstraints = false
        coreTextView.layoutSelfTopEqutoViewBottom(toView: referenceView,offset:0)
        coreTextView.layoutLeftToView(view: referenceView, offset: 0)
        coreTextView.layoutRightToView(toView: referenceView, offsest: 0)
        coreTextView.layoutWidthEqutoSuperView()
        heightConstraint = coreTextView.creteHeightConstraint(height: height)
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
    
    /// 添加textView
    private func appendTextView() {
        coreTextViewArray.append(PYTextView())
    }

    
    // MARK:functions
    var isFirstLayout = true
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout {
//            coreTextView.addConstraint(heightConstraints)
        }
        isFirstLayout = false
    }
    
    
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
    
    private var coreTextViewX: CGFloat {
        return edgeInsets.left
    }
    private var currentCoreTextViewY: CGFloat {
        return coreTextViewArray.last?.frame.maxY ?? edgeInsets.top
    }
    
    private var coreTextViewArray = [PYTextView]()
}
