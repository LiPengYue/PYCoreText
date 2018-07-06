//
//  PYAttributedHandler.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/25.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit
/**
 链接：https://www.jianshu.com/p/847ccf163bc3
 */
/// 数据接口， 根据不同类型的数据，生成NSAttributeString
class PYAttributedHandler: NSObject,NSCopying {
    
    struct Font {
        var name: String = ""
        var size: CGFloat = 0
        var affineTransform: CGAffineTransform? = nil
        init(name: String? = nil, size: CGFloat, affineTransform: CGAffineTransform? = nil) {
            self.name = name ?? "PingFangSC-Regular"
            self.size = size
            self.affineTransform = affineTransform
        }
    }
    
    func py_copy() -> PYAttributedHandler { return self.copy() as! PYAttributedHandler }
    
    
    var text: String?
    // 字体形状属性：必须是CFNumberRef对象默认为0，非0则对应相应的字符形状定义，如1表示传统字符形状
    //    var kCTCharacterShapeAttributeName: Bool
    
    /// 字体属性：必须是CTFont对象
    var font: Font?
    
    /// 字符间隔
    var characterSpacing: CGFloat?
    
    /// 设置是否使用连字属性：设置为0，表示不使用连字属性。标准的英文连字有FI,FL.默认值为1，既是使用标准连字。也就是当搜索到f时候，会把fl当成一个文字。必须是CFNumberRef 默认为1,可取0,1,2
    var ligature: NSInteger?
    
    var textBackgroundColor: UIColor?
    
    /// 字体颜色属性：默认为black
    var foregroundColor: UIColor = UIColor.black
    
    /// 上下文的字体颜色属性: 默认为False
    var foregroundColorFromContext: Bool = false
    
    /// 段落样式属性
    var paragraphStyle: NSMutableParagraphStyle?
    
    /// 笔画线条宽度：必须是CFNumberRef对象，默为0.0f，标准为3.0f
    var strokeWidth: CGFloat?
    
    /// 笔画的颜色属性：必须是CGColorRef 对象，默认为前景色
    var strokeColor: UIColor?
    
    /// 设置字体的上下标属性：必须是CFNumberRef对象 默认为0,可为-1为下标,1为上标，需要字体支持才行。如排列组合的样式Cn1
    var superscript: NSInteger?
    
    /// 字体下划线颜色属性：必须是CGColorRef对象，默认为前景色
    var underlineColor: UIColor?
    
    /// 字体下划线样式属性
    var underlineStyle: LineStyle?
    
    /// 进行修改下划线风格
    var underlineStyleModifiers:LineStyleModifiers?
    
    /// 文字的字形方向属性：必须是CFBooleanRef 默认为false，false表示水平方向，true表示竖直方向
    var verticalForms: Bool = false
    
    /// 字体信息属性：必须是CTGlyphInfo对象
    var glyphInfo:CTGlyphInfo?
    
    /// 阴影 颜色
    var shadowColor: UIColor?
    
    /// 阴影 offset
    var shadowOffset: CGSize?
    
    /// 删除线 样式
    var strikethroughStyle: LineStyle?
    
    /// 删除线 宽度
//    var strikethroughStyleModifiers: CGFloat?
    
    /// 删除线 颜色
    var strikethroughColor: UIColor?
    
    /// 偏移距离
    var baselineOffset: CGFloat?
    
    /// CTRun 委托属性：必须是CTRunDelegate对象
    weak var runDelegate: CTRunDelegate?
    var attributes: [String:Any]?
    
    /// 获取富文本 配置的字典
    ///
    /// - Returns: dic
    func getAttributes() -> [CFString:Any] { return getAttributeDic() }
    
    /// 创建MutableAttributedString
    ///
    /// - Returns: MutableAttributedString 如果self.text 为nil 则返回nil
    func createMutableAttributedStringIfExsitStr() -> NSMutableAttributedString? { return createAttribtedString() }
    
    func createAttributedString(text: String) -> NSMutableAttributedString? { return createAttribtedString(str: text) }
}


extension PYAttributedHandler {
    enum LineStyleModifiers: NSInteger {
        case patternSolid = 0
        case patternDot = 1
        case patternDash = 2
        case patternDashDot = 3
        case patternDashDotDot = 4
    }
    enum LineStyle: NSInteger {
        /// 单线
        case single = 0
        /// 下划线加粗
        case thick = 1
        /// 双线
        case double = 2
    }
}

private extension PYAttributedHandler {
    func getLineStyleModifiers(style: LineStyleModifiers) -> Int32 {
        var rawValue: Int32 = 0
        let temp = style
        switch temp {
        case .patternDash:
            rawValue = CTUnderlineStyleModifiers.patternDash.rawValue
        case .patternSolid:
            rawValue = CTUnderlineStyleModifiers.patternSolid.rawValue
        case .patternDot:
            rawValue = CTUnderlineStyleModifiers.patternDot.rawValue
        case .patternDashDot:
            rawValue = CTUnderlineStyleModifiers.patternDashDot.rawValue
        case .patternDashDotDot:
            rawValue = CTUnderlineStyleModifiers.patternDashDotDot.rawValue
        }
        return rawValue
    }
    
    func getLineStyle(style: LineStyle) -> Int32 {
        var rawValue:Int32 = 0
        switch style {
        case .double:
            rawValue = CTUnderlineStyle.double.rawValue
        case .single:
            rawValue = CTUnderlineStyle.single.rawValue
        case .thick:
            rawValue = CTUnderlineStyle.thick.rawValue
        }
        return rawValue
    }
    
    func getAttributeDic() -> [CFString:Any] {
        var dic = [CFString:Any]()
        if let temp = font {
            let fontName = temp.name as CFString
            
            let fontSize = temp.size
            let font: CTFont?
            if var fontAffineTransform = temp.affineTransform {
                font = CTFontCreateWithName(fontName, fontSize, &fontAffineTransform)
            }else{
                font = CTFontCreateWithName(fontName, fontSize, nil)
            }
            dic[kCTFontAttributeName] = font
        }
        
        if let temp = characterSpacing {
            dic[kCTKernAttributeName] = temp
        }
        if let temp = ligature {
            dic[kCTLigatureAttributeName] = temp
        }
        
        dic[NSBackgroundColorAttributeName as CFString] = textBackgroundColor
        
        dic[NSForegroundColorAttributeName as CFString] = foregroundColor
        
        dic[kCTForegroundColorFromContextAttributeName] = foregroundColorFromContext
        
        if let temp = paragraphStyle {
            dic[NSParagraphStyleAttributeName as CFString] = temp
        }
        
        if let temp = strokeWidth {
            dic[kCTStrokeWidthAttributeName] = temp
        }
        
        if let temp = strokeColor {
            dic[NSStrokeColorAttributeName as CFString] = temp
        }
        
        if let temp = superscript {
            dic[kCTSuperscriptAttributeName as CFString] = temp
        }
        
        if let temp = underlineColor {
            dic[NSUnderlineColorAttributeName as CFString] = temp
        }
        
        if let temp = underlineStyle {
            dic[kCTUnderlineStyleAttributeName] = getLineStyle(style: temp)
        }
        
        if let temp = underlineStyleModifiers {
            let rawValue: Int32 = getLineStyleModifiers(style: temp)
            let style: Int32? = dic[kCTUnderlineStyleAttributeName] as? Int32
            dic[kCTUnderlineStyleAttributeName] = rawValue + (style ?? 0)
        }
        
        dic[kCTVerticalFormsAttributeName] = verticalForms
        
        // 删除线
        if let temp = strikethroughStyle {
            let style = getLineStyle(style: temp)
            dic[NSStrikethroughStyleAttributeName as CFString] = style
            baselineOffset = baselineOffset == nil ? 0 : baselineOffset
        }
        
        if let strikethroughColor = strikethroughColor {
            dic[NSStrikethroughColorAttributeName as CFString] = strikethroughColor
        }
        
        if let baselineOffset = baselineOffset {
            dic[NSBaselineOffsetAttributeName as CFString] = baselineOffset
        }
        
        if let temp = glyphInfo {
            dic[kCTGlyphInfoAttributeName] = temp
        }
        
        if let temp = runDelegate {
            dic[kCTRunDelegateAttributeName] = temp
        }
        return dic
    }
    
    func createAttribtedString(str: String? = nil) -> NSMutableAttributedString? {
        let stringtemp = str == nil ? text : str
        
        guard let string = stringtemp else{
            return nil
        }
        let dic = getAttributes()
        attributes = dic as [String:Any]
        let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: string)
        let range = NSRange.init(location: 0, length: attributedString.length)
        attributedString.addAttributes(attributes ?? [String:Any](), range: range)
        return attributedString
    }
    
}


extension PYAttributedHandler {
    override func copy() -> Any {
        return copy_private()
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = copy_private()
        return copy
    }
    
    
    private func copy_private () -> PYAttributedHandler {
        let copy = PYAttributedHandler.init()
        
        copy.text = self.text
        copy.font = self.font
        copy.characterSpacing = self.characterSpacing
        copy.ligature = self.ligature
        copy.textBackgroundColor = self.textBackgroundColor
        copy.foregroundColor = self.foregroundColor
        copy.foregroundColorFromContext = self.foregroundColorFromContext
        copy.paragraphStyle = self.paragraphStyle
        copy.strokeWidth = self.strokeWidth
        copy.strokeColor = self.strokeColor
        copy.superscript = self.superscript
        copy.underlineColor = self.underlineColor
        copy.underlineStyle = self.underlineStyle
        copy.underlineStyleModifiers = self.underlineStyleModifiers
        copy.verticalForms = self.verticalForms
        copy.glyphInfo = self.glyphInfo
        copy.shadowColor = self.shadowColor
        copy.shadowOffset = self.shadowOffset
        copy.strikethroughStyle = self.strikethroughStyle
        copy.strikethroughColor = self.strikethroughColor
        copy.baselineOffset = self.baselineOffset
        copy.runDelegate = self.runDelegate
        copy.attributes = self.attributes
        return copy
    }
}


