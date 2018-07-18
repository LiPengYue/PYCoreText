//
//  PYTextView.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/27.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

protocol PYTextViewDelegate: NSObjectProtocol {
    func drawImage(imageModel: PYCoreTextImageBaseModel, context: CGContext)
}


/// 绘制text
class PYTextView: UIView {
   
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - properties
    var attributedString: NSMutableAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
    var isAutoLayoutSize: Bool = false
    var textFrame: PYFrameHander? {
        didSet {
            textFrame?.reloadProperty(textView: self)
            setNeedsDisplay()
//            textView.attributedText = textFrame?.attributedString
        }
    }
   
    var imageModelArray: [PYCoreTextImageBaseModel]?
    /// 绘图代理
    weak var textViewDelegate: PYTextViewDelegate?
    
    // MARK: - func
    
    // MARK: network
    func reloadData(textFrame: PYFrameHander?,imageModelArray: [PYCoreTextImageBaseModel]?) {
        self.imageModelArray = imageModelArray
        self.textFrame = textFrame
    }
    // MARK: handle views
    
    ///设置
    private func setup() {
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: handle event
    ///事件
    private func registerEvent() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    // MARK:functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let textFrame = self.textFrame else{ return }
        textFrame.reloadProperty(textView: self)
        guard let ctFrame = textFrame.ctFrame else{ return }
        
        /// 转化坐标系
        conversionContext(context: context)
//        textFrame.drawData(context: context)
        /// 绘制文字
        CTFrameDraw(ctFrame, context)
//        let linePointers = CTFrameGetLines(ctFrame)
//        let count = CFArrayGetCount(linePointers)
//
//
//        for i in 0 ..< 1 {
//            let linePoint = CFArrayGetValueAtIndex(linePointers, i)
//            let line = unsafeBitCast(linePoint, to: CTLine.self)
//            CTLineDraw(line, context)
//        }
        /// 绘图
//        drawImageIfHaveImage(ctFrame: ctFrame, context: context)
    }
    // MARK:life cycles
    
    // MARK: lazy loads
    let textView: UITextView = UITextView()
}


private extension PYTextView {
    func conversionContext(context: CGContext) {
        /// 转化坐标系
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1, y: -1)
    }
    func drawText(ctFrame: CTFrame, context: CGContext,_ loopLinesBlock:((_ line: CTLine, _ linePoint: CGPoint)->())?) {
        /// 获取每一行
        let ctLines = CTFrameGetLines(ctFrame)
        let ctLinesCount = CFArrayGetCount(ctLines)
        
        /// 每行的origin
        var lineOrigins = Array<CGPoint>.init(repeating: CGPoint.zero, count: ctLinesCount)
        CTFrameGetLineOrigins(ctFrame, CFRange.init(location: 0, length: 0), &lineOrigins)
        
        let path = CTFrameGetPath(ctFrame)
        let colRect = path.boundingBoxOfPath
        
        var imageIdex: NSInteger = 0
        for index in 0 ..< ctLinesCount {
            
            let lineUnsafePoint = CFArrayGetValueAtIndex(ctLines, index)
            /// line
            let line = unsafeBitCast(lineUnsafePoint, to: CTLine.self)
            
            
            // 调整成所需要的坐标
            context.textPosition = lineOrigins[index]
            CTLineDraw(line, context)
        }
    }
    /// 绘图如果有图片的话
    func drawImageIfHaveImage(ctFrame: CTFrame, context: CGContext) {
       
        
        /// 获取每一行
        let ctLines = CTFrameGetLines(ctFrame)
        let ctLinesCount = CFArrayGetCount(ctLines)
        
        /// 每行的origin
        var lineOrigins = Array<CGPoint>.init(repeating: CGPoint.zero, count: ctLinesCount)
        CTFrameGetLineOrigins(ctFrame, CFRange.init(location: 0, length: 0), &lineOrigins)
        
        let path = CTFrameGetPath(ctFrame)
        let colRect = path.boundingBoxOfPath
        
        var imageIdex: NSInteger = 0
        for index in 0 ..< ctLinesCount {
            let lineUnsafePoint = CFArrayGetValueAtIndex(ctLines, index)
            /// line
            let line = unsafeBitCast(lineUnsafePoint, to: CTLine.self)
            // 调整成所需要的坐标
            context.textPosition = lineOrigins[index]
            CTLineDraw(line, context)
            
            guard let imageModelArray = imageModelArray else { break }
            if imageModelArray.count <= 0 { break }
            let runs = CTLineGetGlyphRuns(line)
            let runsCount = CFArrayGetCount(runs)
            
            for runIndex in  0 ..< runsCount {
                let runUnsafePointer = CFArrayGetValueAtIndex(runs, runIndex)
                let run = unsafeBitCast(runUnsafePointer, to: CTRun.self)
                /// 是否为图片站位图
                if !isImageRun(run: run) { continue }
                let imageModel = imageModelArray[imageIdex]
                imageIdex += 1
                let charIndex = CTRunGetStringRange(run)
                let offsetX = CTLineGetOffsetForStringIndex(line, charIndex.location, nil)
                let runBounds = getImageRunFrame(run: run, lineOringinPoint: lineOrigins[index], offsetX: offsetX)
                // 获得ctframe的绘制区域
                // 计算此绘制区域的范围
                // 算在此区域中空白字符的位置
                let delegateBounds = runBounds.offsetBy(dx: colRect.origin.x,
                                                        dy: colRect.origin.y)
                imageModel.framePrivate = delegateBounds
                let imageName = imageModel.url ?? ""
                let image = UIImage.init(named: imageName)
                let imageData = image?.compressImage(maxLength: 20480)
                let img = UIImage.init(data: imageData ?? Data())
                context.draw((img?.cgImage!)!, in: delegateBounds)
            }
        }
    }
    
    func isImageRun(run: CTRun) -> Bool {
        
        let runAttributesUnsafePointer = CTRunGetAttributes(run)
        
        let runAttributes = unsafeBitCast(runAttributesUnsafePointer, to: NSDictionary.self)
        
        guard runAttributes[k_PYCoreTextImage] as? String == k_PYCoreTextImage else{
            return false
        }
        return true
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
        //获取CTRun的宽度
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
