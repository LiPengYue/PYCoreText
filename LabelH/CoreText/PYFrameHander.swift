//
//  PYFrameHander.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/27.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit
import CoreText

/// CTFrame
class PYFrameHander: NSObject {

    // MARK: - init
    init(string: NSAttributedString?, layout: Layout? = nil) {
        attributedString_private = string
        super.init()
        if let layout = layout {
            reloadProperty(textLayout: layout)
        }
    }
    
    //MARK: - open
    var isAutoSize: Bool = true {
        didSet {
            
        }
    }
    
    //MARK: open proprty
    /// 最左侧的位置
    var leftX: CGFloat { return leftX_private }
    
    /// 最右侧的位置
    var rightX: CGFloat { return rightX_private }
    
    /// 最小y
    var topY: CGFloat { return topY_private }
    
    /// 最大y
    var bottomY: CGFloat { return bottomY_private }
    
    /// cgPath
    var cgPath: CGMutablePath? { return getPath() }
    
    /// ctFrame
    var ctFrame: CTFrame? { return getFrame() }
    
    /// layout
    var layout: Layout? { return textLayout }
    
    /// 最大string size
    var  attributedMaxSize: CGSize { return getAttributedSize_private() }
    
    weak var textView: PYTextView? { return textView_private }
    
    // MARK: open func
    /// 更新数据 
    open func reloadProperty(textLayout: Layout? = nil, textView: PYTextView? = nil) {
        if let textLayoutTemp = textLayout { self.textLayout = textLayoutTemp }
        if let textViewTemp = textView { textView_private = textViewTemp }
        reLoadData()
    }
    
   
    
    
    // -------------------------------------------------
    // MARK: - private
    // MARK: private proprty
    private var textLayout: Layout? { didSet { setTextLayout() } }
    private var leftX_private: CGFloat = 0
    private var rightX_private: CGFloat = 0
    private var topY_private: CGFloat = 0
    private var bottomY_private: CGFloat = 0
    private var attributedString_private: NSAttributedString?
    
    private var maxHeight_private: CGFloat = 0
    private var width_private: CGFloat = 0
    
    private var insets_private: UIEdgeInsets = .zero
    private var cgPath_private: CGMutablePath?
    private var ctFrame_private: CTFrame?
    private var attributedSize_private: CGSize = CGSize.zero
    
    private weak var textView_private: PYTextView?
    
    
    //MARK: private func
    /// 创建 ctFrame 并更新self.ctFrame 与self.cgPath
    ///
    /// - Returns: ctFrame
    private func setTextLayout() {
        reLoadData()
    }
    private func setProperty(size: CGSize) {
        
        let height = size.height
        var maxHeight: CGFloat = layout?.maxHeight ?? 0
        if (isAutoSize || maxHeight <= 0) && (height > 0) { maxHeight = height }
        let minH = layout?.minHeight ?? 0
        if (minH > 0) && (minH > maxHeight) { maxHeight = minH }
        maxHeight = abs(maxHeight)
        
        var width = size.width
        if (width < layout?.minWidth ?? 0) {
            width = layout?.minWidth ?? 0
        }
        maxHeight_private = maxHeight <= 0 ? CGFloat.leastNonzeroMagnitude : maxHeight
//        width_private = layout?.maxwidth ?? 0
        
        insets_private = layout?.insets ?? .zero
        let leftX = insets_private.left
        let rightX = leftX + width_private + insets_private.right
        let topY = insets_private.top
        let bottomY = topY + maxHeight_private + insets_private.bottom
        
        leftX_private = leftX
        rightX_private = rightX
        topY_private = bottomY
        bottomY_private = topY
        
        attributedSize_private = CGSize.init(width: width_private + leftX - rightX, height: maxHeight_private + insets_private.bottom + topY)
    }
    @discardableResult
    private func reLoadData() -> CTFrame? {
        
        guard let attributedString = attributedString_private else{ return nil }
        
        let ctFramesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let range = CFRange.init(location: 0,length: 0)
        
        width_private = layout?.maxWidth ?? 0
        let standardSize = CGSize.init(width: width_private,
                                       height: CGFloat.greatestFiniteMagnitude)
        
        let size =  CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter,range,nil,standardSize,nil)
        let path = createNewPath(size: size)
  
        let cfRange = CFRange.init(location: 0, length: 0)
        let ctFrame = CTFramesetterCreateFrame(ctFramesetter,
                                               cfRange,
                                               path,
                                               nil)
        
        ctFrame_private = ctFrame
        return ctFrame
    }
    
    /// 创建 CGMutablePath 并更新self.cgPath
    ///
    /// - Returns: CGMutablePath
    @discardableResult
    private func createNewPath(size: CGSize) -> CGMutablePath {
        
        setProperty(size: size)
        
        let textViewH = textView?.bounds.height ?? 0
        let layoutTop = layout?.insets.top ?? 0
        let topY_path = textViewH - layoutTop
        let layoutBottom = layout?.insets.bottom ?? 0
        
        var bottomMargin = layoutTop + layoutBottom - textViewH
        bottomMargin = bottomMargin <= 0 ? 0 : bottomMargin

        let bottomY_path = layoutBottom//textViewH - maxHeight_private - layoutTop + bottomMargin
        
        let path = CGMutablePath.init()
        path.move(to: CGPoint.init(x: leftX, y:   bottomY_path))
        path.addLine(to: CGPoint.init(x: rightX, y: bottomY_path))
        path.addLine(to: CGPoint.init(x: rightX, y: topY_path))
        path.addLine(to: CGPoint.init(x: leftX, y: topY_path))
        path.closeSubpath()

        cgPath_private = path
        return path
    }
    
    private func getFrame() -> CTFrame? {
        return ctFrame_private == nil ? reLoadData() : ctFrame_private
    }
    private func getPath() -> CGMutablePath? {
        return cgPath_private
    }
    private func getAttributedSize_private() -> CGSize {
        return attributedSize_private 
    }
    deinit {
        print("✅")
    }
}

extension PYFrameHander {
    struct Layout {
        /// attributed string 最大 宽高
        var maxHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        /// 最小高度
        var minHeight: CGFloat = 0
        /// 最小款度
        var minWidth: CGFloat = 0
        /// string的内间距
        var insets: UIEdgeInsets = UIEdgeInsets.zero
        /// 最多有多少字符
        var maxStringLenth: NSInteger? = 0
        init(minHeight: CGFloat? = -1,maxHeight: CGFloat? = 0,minWidth: CGFloat? = -1, maxWidth: CGFloat, insets: UIEdgeInsets, maxStringLenth: NSInteger? = 0) {
            self.maxHeight = maxHeight ?? CGFloat.greatestFiniteMagnitude
            self.maxWidth = maxWidth
            self.insets = insets
            self.maxStringLenth = maxStringLenth
            self.minHeight = minHeight ?? -2
            self.minWidth = minWidth ?? -2
        }
    }
}

