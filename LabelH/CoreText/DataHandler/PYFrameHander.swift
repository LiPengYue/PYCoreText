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
    var attributedMaxSize: CGSize { return getAttributedSize_private() }
    var attributedMaxH: CGFloat { return getAttributedSize_private().height }
    var attributedString: NSAttributedString? { return attributedString_private }
    weak var textView: PYTextView? { return textView_private }
    var subFrameData: SubFrameData { return subFrameData_private }
    
    /// 获取attributedString的高度
    ///
    /// - Parameters:
    ///   - attributedString: 默认为self.attributeString
    ///   - W: 参考 宽度
    /// - Returns: attributedString 的高度
    func getAttributedHeight(attributedString: NSAttributedString? = nil ,W: CGFloat) -> CGFloat? {
        return getAttributedHeight_private(attributedString: attributedString, W: W)
    }
    
    // MARK: open func
    /// 更新数据 
    open func reloadProperty(textLayout: Layout? = nil, textView: PYTextView? = nil) {
        if let textLayoutTemp = textLayout { self.textLayout = textLayoutTemp }
        if let textViewTemp = textView { textView_private = textViewTemp }
        reLoadData()
    }
    
    open func drawData(context: CGContext) {
        self.subFrameData.enumeratePropertyUsingBlock { (isStop,index,path,ctFrame,attributedStr,frame) in
            
            guard let ctFrame = ctFrame else { return isStop = true}
            CTFrameDraw(ctFrame, context)
        }
    }
    
    // MARK: - private
    // MARK: private proprty
    private var isAutoHeight: Bool = true
    private var isAutoWeight: Bool = false
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
    private var currenMaxHeight: CGFloat = 0
    private var subFrameData_private: SubFrameData = SubFrameData()
    //MARK: private func
    /// 创建 ctFrame 并更新self.ctFrame 与self.cgPath
    ///
    /// - Returns: ctFrame
    private func setTextLayout() {
        reLoadData()
    }
    private func setProperty(size: CGSize) {
        attributedSize_private = size
        
        let textVieSize = textView?.bounds.size ?? .zero
        var textViewW = textVieSize.width
        var height = textVieSize.height
        
        if isAutoWeight || (textViewW == 0 && height == 0) {
            attributedSize_private.width = textViewW
            textViewW = size.width
        }
        if isAutoHeight {
            height = size.height
        }
        var maxHeight: CGFloat = height///layout?.maxHeight ?? 0
        maxHeight = abs(maxHeight)
        
        maxHeight_private = maxHeight <= 0 ? CGFloat.leastNonzeroMagnitude : maxHeight
        
        insets_private = layout?.insets ?? .zero
        let leftX = insets_private.left
        let rightX = textViewW - insets_private.right
        let topY = insets_private.top
         let bottomY = topY + maxHeight_private + insets_private.bottom
        var width = size.width
        let midWidth = rightX - leftX
        width = width < midWidth ? width : midWidth
        
        width_private = width
        leftX_private = leftX
        rightX_private = rightX
        topY_private = topY
        bottomY_private = bottomY
    }
    @discardableResult
    private func reLoadData() -> CTFrame? {
        
        guard let attributedString = attributedString_private else{ return nil }
        
        guard let textView = textView else { return nil}
        width_private = textView.frame.width
        reloadMaxFrameData(attributedString: attributedString)
        return ctFrame
    }
    private func reloadMaxFrameData(attributedString: NSAttributedString) {
        let framesetterAndSizeValue = getStringCTFramesetterAndSize(attributed: attributedString)
        let size = framesetterAndSizeValue.1
        setProperty(size: size)
        let path = createCtFramePath(y: layout?.insets.top ?? 0,
                                     size: size)
        let ctFramesetter = framesetterAndSizeValue.0
        ctFrame_private = setupCtFrame(ctFramesetter: ctFramesetter, path: path)
    }
    
    func cutAttribtedStringCreateSubData (subLength: NSInteger) {
        let count = (attributedString?.length ?? 0) / subLength
        var currentmaxY: CGFloat = layout?.insets.top ?? 0
        for i in 0 ... count {
            // get attributed
            let strAttributed = setupSubFrameDataSubAttributeds(i: i, subLength: subLength)
            guard let str = strAttributed else { break }
          
            // get size and framesetter
            let framesetterAndSizeValue = getStringCTFramesetterAndSize(attributed: str)
            let ctFramesetter = framesetterAndSizeValue.0
            let size = framesetterAndSizeValue.1
            let currentRect = CGRect.init(x: leftX, y: currentmaxY, width: size.width, height: size.height)
            subFrameData_private.frameArray.append(currentRect)
            currentmaxY = currentRect.maxY
            
            // get path
            let path = createCtFramePath(y: currentRect.minY, size: size)
            subFrameData_private.subFramePaths.append(path)
            
            // get ctFrame
            let frame = setupCtFrame(ctFramesetter: ctFramesetter, path: path)
            subFrameData_private.subCtFrames.append(frame)
        }
    }
    
    private func setupSubFrameDataSubAttributeds(i: Int, subLength: Int) -> NSAttributedString? {
        let attributedStrLength = attributedString?.length ?? 0
        let lastLength = i * subLength
        if lastLength >= attributedStrLength { return nil }
        var currenLength = subLength
        if attributedStrLength < subLength + lastLength {
            currenLength = attributedStrLength - lastLength
        }
        
        let subAttributedString = attributedString?.attributedSubstring(from: NSRange.init(location: lastLength, length: currenLength))
        if let subAttributedString = subAttributedString {
            subFrameData_private.subAttributeStrings.append(subAttributedString)
        }
        return subAttributedString
    }
   
    private func getStringCTFramesetterAndSize(attributed: NSAttributedString) -> (CTFramesetter, CGSize) {
        let ctFramesetter = CTFramesetterCreateWithAttributedString(attributed)
        let range = CFRange.init(location: 0,length: 0)

        let standardSize = CGSize.init(width: width_private,
                                       height: CGFloat.greatestFiniteMagnitude)

        let size =  CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter,
                                                                 range,
                                                                 nil,
                                                                 standardSize,
                                                                 nil)
        return (ctFramesetter,size)
    }
   
    private func setupCtFrame(ctFramesetter: CTFramesetter,path: CGPath) -> CTFrame {
        let cfRange = CFRange.init(location: 0, length: 0)
        let ctFrame = CTFramesetterCreateFrame(ctFramesetter,
                                               cfRange,
                                               path,
                                               nil)
        return ctFrame
    }
    
    /// 创建 CGMutablePath 并更新self.cgPath
    ///
    /// - Returns: CGMutablePath
    @discardableResult
    private func createCtFramePath(y: CGFloat,size: CGSize) -> CGMutablePath {
        
//        let subFrameH = size.height
//        let layoutTop = y
//        let topY_path = subFrameH - layoutTop
//        let layoutBottom = layout?.insets.bottom ?? 0
//
//        var bottomMargin = layoutTop + layoutBottom - subFrameH
//        bottomMargin = bottomMargin <= 0 ? 0 : bottomMargin
//
//        let bottomY_path = layoutBottom//textViewH - maxHeight_private - layoutTop + bottomMargin
        let textViewH = textView?.bounds.height ?? 0
        let top = textViewH - y
        let bottom = textViewH - (y + size.height)
        
        let path = CGMutablePath.init()
        path.move(to: CGPoint.init(x: leftX, y: bottom))
        path.addLine(to: CGPoint.init(x: rightX, y: bottom))
        path.addLine(to: CGPoint.init(x: rightX, y: top))
        path.addLine(to: CGPoint.init(x: leftX, y: top))
        path.closeSubpath()
        return path
    }
    /// 创建 CGMutablePath 并更新self.cgPath
    ///
    /// - Returns: CGMutablePath
    @discardableResult
    private func createSuperFramePath(size: CGSize) -> CGMutablePath {
        
        setProperty(size: size)
        
        let textViewH = textView?.bounds.height ?? 0
        let layoutTop = layout?.insets.top ?? 0
        let topY_path = textViewH - layoutTop
        let layoutBottom = layout?.insets.bottom ?? 0
        
        var bottomMargin = layoutTop + layoutBottom - textViewH
        bottomMargin = bottomMargin <= 0 ? 0 : bottomMargin

        let bottomY_path = layoutBottom//textViewH - maxHeight_private - layoutTop + bottomMargin
        
        let path = CGMutablePath.init()
        path.move(to: CGPoint.init(x: leftX, y: bottomY_path))
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
    private func getAttributedHeight_private(attributedString: NSAttributedString? = nil ,W: CGFloat) -> CGFloat? {
        
        guard let string =  attributedString ?? attributedString_private else{ return nil}
        
        let standardSize = CGSize.init(width: W,
                                       height: CGFloat.greatestFiniteMagnitude)
        
        let ctFramesetter = CTFramesetterCreateWithAttributedString(string)
        let range = CFRange.init(location: 0,length: 0)
        
        let size =  CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter,
                                                                 range,
                                                                 nil,
                                                                 standardSize,
                                                                 nil)
        return size.height
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
    
    struct SubFrameData {
        var currentIndex: NSInteger = 0
        var subFramePaths: [CGPath] = [CGPath]()
        var subCtFrames: [CTFrame] = [CTFrame]()
        var subAttributeStrings: [NSAttributedString] = [NSAttributedString]()
        var frameArray: [CGRect] = [CGRect]()
        
        init() { }
        
        func getPath(index: Int) -> CGPath? {
            guard subFramePaths.count > index else {
                return nil
            }
            return subFramePaths[index]
        }
        
        func getCtFrame(index: Int) -> CTFrame? {
            guard subCtFrames.count > index else {
                return nil
            }
            return subCtFrames[index]
        }
        
        func getAttributedStr(index: Int) -> NSAttributedString? {
            guard subAttributeStrings.count > index else {
                return nil
            }
            return subAttributeStrings[index]
        }
        
        func getFrameArray(index: Int) -> CGRect? {
            guard frameArray.count > index else {
                return nil
            }
            return frameArray[index]
        }
        
        func getValue(index: Int) -> (path: CGPath?,
            ctFrame: CTFrame?,
            subAttributedStr: NSAttributedString?,
            frame: CGRect?) {
             return (getPath(index: index),
                     getCtFrame(index: index),
                     getAttributedStr(index: index),
                     getFrameArray(index: index)
                )
        }
        
        /// 遍历获取元素
        ///
        /// - Parameter block: 每次遍历后的值 if isStop = true { break }
        func enumeratePropertyUsingBlock(block:
            ((_ isStop:inout Bool,
            _ index:NSInteger?,
            _ path:CGPath?,
            _ ctFrame: CTFrame?,
            _ attributeStr: NSAttributedString?,
            _ frame: CGRect?)->())) {
            let count = subFramePaths.count
            var isStop = false
            for i in 0 ..< count {
                let value = getValue(index: i)
                block(&isStop,
                      i,
                      value.path,
                      value.ctFrame,
                      value.subAttributedStr,
                      value.frame)
                if isStop { break }
            }
        }
    }
}

