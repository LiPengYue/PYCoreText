//
//  Label+Getheight.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/25.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

extension UILabel {
    enum GetSizeType_ENUM: Int {
        case text = 0
        case attributeString
        
    }
    
    ///  自动计算了label 的宽度，在此之前，需要有label的宽度约束
    ///
    /// - Returns:
    
    
    /// 获取label的高度,
    ///
    /// - Parameters:
    ///   - type: 计算text 还是attributeText，如果不传则（如果有text的话，优先计算attributeText的height，没有attributeText则计算text的height，如果两个都没有值则返回0）
    ///   - width: width的最大值。如果不传则（自动计算了label 的width，在此之前，需要有label的width约束）
    /// - Returns: 文本实际高度的最大值
    func getLabelHeight(type: GetSizeType_ENUM? = nil, width: CGFloat? = nil) -> CGFloat {
        var w: CGFloat = width ?? -1
        var h: CGFloat = CGFloat.greatestFiniteMagnitude
        if w <= 0 {
            if frame.width == 0 {
                layoutIfNeeded()
            }
            guard frame.width != 0 else {
                print("🌶🌶🌶： 计算label的height失败，因为其width为0")
                return 0
            }
            w = frame.width
        }
        
        if let attributedText = attributedText, let type = type, type == .attributeString{
            
            h = attributedText.getSize(width: w, height: h).height
        }else if let text = text {
            
            h = text.getLabHeigh(font: font, width: w)
        }else {
            print("label没有text，或者attribute")
        }
        return h
    }
    
    
    /// 获取label的widht,
    ///
    /// - Parameters:
    ///   - type: 计算text 还是attributeText，如果不传则（如果有text的话，优先计算attributeText的width，没有attributeText则计算text的width，如果两个都没有值则返回0）
    ///   - height: 高度的最大值。如果不传则（自动计算了label 的height，在此之前，需要有label的height约束）
    /// - Returns: 文本的宽度最大值
    func getLabelWidth(type: GetSizeType_ENUM? = nil, height: CGFloat? = nil) -> CGFloat {
        
        var w: CGFloat = CGFloat.greatestFiniteMagnitude
        var h: CGFloat = height ?? -1
        if h <= 0 {
            if frame.width == 0 {
                layoutIfNeeded()
            }
            guard frame.height != 0 else {
                print("🌶🌶🌶： 计算label的width失败，因为其height为0")
                return 0
            }
            h = frame.height
        }
        
        if let attributedText = attributedText, let type = type, type == .attributeString{
            
            w = attributedText.getSize(width: w, height: h).width
        }else if let text = text {
            
            w = text.getLabWidth(font: font, height: h)
        }else {
            print("label没有text，或者attribute")
        }
        return w
    }
}


// MARK: - get NSAttributedString height
extension NSAttributedString {
    
    /// 根据给定的范围计算宽高，如果计算宽度，则请把宽度设置为最大，计算高度则设置高度为最大
    ///
    /// - Parameters:
    ///   - width: 宽度的最大值
    ///   - height: 高度的最大值
    /// - Returns: 文本的实际size
    func getSize(width: CGFloat,height: CGFloat) -> CGSize {
        let attributed = self
        let ctFramesetter = CTFramesetterCreateWithAttributedString(attributed)
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        let path = CGPath.init(rect: rect, transform: nil)
        let ctFrame = CTFramesetterCreateFrame(ctFramesetter, CFRange.init(location: 0, length: attributed.length), path, nil)
        
        /// 获取lines
        let cfLines = CTFrameGetLines(ctFrame)
        let linesCount = CFArrayGetCount(cfLines)
        
        /// 获取每行的宽高
        var maxWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        var lineOrigins = Array<CGPoint>.init(repeating: CGPoint.zero, count: linesCount)
        CTFrameGetLineOrigins(ctFrame, CFRange.init(location: 0, length: 0), &lineOrigins)
        
        for i in 0 ..< linesCount {
            /// line
            let ctLineUnsafePointer = CFArrayGetValueAtIndex(cfLines, i)
            let ctLine = unsafeBitCast(ctLineUnsafePointer, to: CTLine.self)
            
            /// w ascent descent leading
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            var leading: CGFloat = 0
            
            let lineW: CGFloat = CGFloat(CTLineGetTypographicBounds(ctLine, &ascent, &descent, &leading))
            
            totalHeight += ascent + descent + leading
            maxWidth = maxWidth > lineW ? maxWidth : lineW
            
//            let runs = CTLineGetGlyphRuns(ctLine)
//            let runsCount = CFArrayGetCount(runs)
//
////            for runIndex in  0 ..< runsCount {
////                let runUnsafePointer = CFArrayGetValueAtIndex(runs, runIndex)
////                let run = unsafeBitCast(runUnsafePointer, to: CTRun.self)
////
////                let charIndex = CTRunGetStringRange(run)
////                let offsetX = CTLineGetOffsetForStringIndex(ctLine, charIndex.location, nil)
////                let a = CTRunGetAttributes(run)
////
////                let runBounds = getImageRunFrame(run: run, lineOringinPoint: lineOrigins[linesCount - 1], offsetX: offsetX)
////                totalHeight = runBounds.maxY > totalHeight ? runBounds.maxY : totalHeight
////            }
            
        }
        
        return CGSize.init(width: ceil(maxWidth + 1), height: ceil(totalHeight + 1))
    }
    
    func getImageRunFrame(run: CTRun, lineOringinPoint: CGPoint, offsetX: CGFloat) -> CGRect {
        /// 计算位置 大小
        var runBounds = CGRect.zero
        var h: CGFloat = 0
        var w: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var asecnt: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        
        
        let cfRange = CFRange.init(location: 0, length: 0)
        
        w = CGFloat(CTRunGetTypographicBounds(run, cfRange, &asecnt, &descent, &leading))
        h = asecnt + descent + leading
        /// 获取具体的文字距离这行原点的距离 || 算尺寸用的
        x = offsetX + lineOringinPoint.x
        /// y
        y = lineOringinPoint.y - descent
        runBounds = CGRect.init(x: x, y: y, width: w, height: h)
        return runBounds
    }
}


// MARK: - get String height
extension String {
    func getLabHeigh(font:UIFont,width:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: width, height:  CGFloat(MAXFLOAT))
        
        //        let dic = [NSAttributedStringKey.font:font] // swift 4.0
        let dic = [NSFontAttributeName:font] // swift 3.0
        
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context:nil).size
        
        return ceil(strSize.height) + 1
    }
    ///获取字符串的宽度
    func getLabWidth(font:UIFont,height:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        
        //        let dic = [NSAttributedStringKey.font:font] // swift 4.0
        let dic = [NSFontAttributeName:font] // swift 3.0
        
        let cString = self.cString(using: String.Encoding.utf8)
        let str = String.init(cString: cString!, encoding: String.Encoding.utf8)
        let strSize = str?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return strSize?.width ?? 0
    }
}
