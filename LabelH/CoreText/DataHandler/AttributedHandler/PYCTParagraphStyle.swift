//
//  PYCTParagraphStyle.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/25.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

/// https://blog.csdn.net/xiaoxiaobukuang/article/details/52384800
/// https://www.2cto.com/kf/201609/544172.html
class PYCTParagraphStyle: NSObject {
    
    ///对齐属性
    var alignment: AlignmentEnum?
    ///首行缩进
    var firstLineHeadIndent: CGFloat?
    ///段头缩进
    var headIndent: CGFloat?
    ///段尾缩进
    var tailIndent: CGFloat?
    ///制表符模式
    var tabStops: CTTextTab?
    ///默认tab间隔
    var defaultTabInterval: CGFloat?
    ///换行模式
    var lineBreakMode: LineBreakModeEnum?
    ///多行高
    var lineHeightMultiple: CGFloat?
    ///最大行高
    var maximumLineHeight: CGFloat?
    ///最小行高
    var minimumLineHeight: CGFloat?
    ///行距
    var lineSpacing: CGFloat?
    ///段落间距  在段的未尾（Bottom）加上间隔，这个值为负数。
    var paragraphSpacing: CGFloat = 0.0
    
    ///段落前间距 在一个段落的前面加上间隔。TOP
    var paragraphSpacingBefore: CGFloat?
    ///基本书写方向
    var baseWritingDirection: CTWritingDirection?
    ///最大行距
    var maximumLineSpacing: CGFloat?
    ///最小行距
    var minimumLineSpacing: CGFloat?
    ///行距调整
    var lineSpacingAdjustment: CGFloat?
    var lineBoundsOptions: CGFloat?
    var count = 0
    
    
    /// 根据属性获取 CTParagraphStyle
    ///
    /// - Returns: CTParagraphStyle
    func createParagraphStyle() -> CTParagraphStyle {
        let styleSettings = self.createCTParagraphStyleSettings()
        let count = styleSettings.count
        let size = MemoryLayout.size(ofValue: CGFloat.self)
        lineSpacing = 10
        let settings: [CTParagraphStyleSetting] =
            
            [CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.lineSpacingAdjustment, valueSize:       MemoryLayout<CGFloat>.size, value: &lineSpacing),
             
             CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),
             
             CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing)]
        
        let paragaraph = CTParagraphStyleCreate(settings, 3)
        
        
        return paragaraph
    }
    
    
    
    /// 根据属性创建出对应的setting
    ///
    /// - Returns: setting array
    func createCTParagraphStyleSettings() -> [CTParagraphStyleSetting] {
        var styles = [CTParagraphStyleSetting]()
        if var temp = alignment {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.alignment, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = firstLineHeadIndent {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec:  CTParagraphStyleSpecifier.firstLineHeadIndent, valueSize: size, value: &temp)
            styles.append(style)
            
        }
        if var temp = headIndent {
            let size = MemoryLayout<CGFloat>.size
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.headIndent, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = tailIndent {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.tailIndent, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = tabStops {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.tabStops, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = defaultTabInterval {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.defaultTabInterval, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = lineBreakMode {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.lineBreakMode, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = lineHeightMultiple {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.lineHeightMultiple, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = maximumLineHeight {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.maximumLineHeight, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = minimumLineHeight {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.minimumLineHeight, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = lineSpacing {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.lineSpacingAdjustment, valueSize: size, value: &temp)
            styles.append(style)
        }
        let size = MemoryLayout.size(ofValue: CGFloat.self)
        let paragraphSpacingStyle = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.paragraphSpacing, valueSize: size, value: &paragraphSpacing)
        styles.append(paragraphSpacingStyle)
     
        if var temp = paragraphSpacingBefore {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.paragraphSpacingBefore, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = maximumLineSpacing {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.maximumLineSpacing, valueSize: size, value: &temp)
            
            styles.append(style)
        }
        if var temp = minimumLineSpacing {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.minimumLineSpacing, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = lineSpacingAdjustment {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.lineSpacingAdjustment, valueSize: size, value: &temp)
            styles.append(style)
        }
        if var temp = lineBoundsOptions {
            let size = MemoryLayout.size(ofValue: CGFloat.self)
            let style = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.lineBoundsOptions, valueSize: size, value: &temp)
            styles.append(style)
        }

        
        let countStyle = CTParagraphStyleSetting.init(spec: CTParagraphStyleSpecifier.count, valueSize: size, value: &count)
        styles.append(countStyle)
        
        return styles
    }
    
    ///对其方式
    enum AlignmentEnum: NSInteger {
        ///左对齐
        case Left = 0
        ///右对齐
        case Right = 1
        ///居中对齐
        case Center = 2
        ///文本对齐
        case Justified = 3
        ///自然文本对齐
        case Natural = 4
    }
    enum LineBreakModeEnum: NSInteger {
        ///出现在单词边界时起作用，如果该单词不在能在一行里显示时，整体换行。此为段的默认值。
        case WordWrapping = 0
        ///当一行中最后一个位置的大小不能容纳一个字符时，才进行换行。
        case CharWrapping = 1
        ///超出画布边缘部份将被截除。
        case Clipping = 2
        ///截除前面部份，只保留后面一行的数据。前部份以...代替。
        case TruncatingHead = 3
        ///截除后面部份，只保留前面一行的数据，后部份以...代替。
        case TruncatingTail = 4
        ///在一行中显示段文字的前面和后面文字，中间文字使用...代替。
        case TruncatingMiddle = 5
    }
}
