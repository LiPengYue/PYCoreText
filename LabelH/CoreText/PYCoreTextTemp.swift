//
//  PYCoreTextTemp.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/2.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit
private let ImageName:String = "timg.jpeg"
private let UrlImageName:String = "http://img3.3lian.com/2013/c2/64/d/65.jpg"

class PYCoreTextTemp: UIView {
    var image:UIImage?
    var imageFrameArr:NSMutableArray = NSMutableArray()
    var ctFrame: CTFrame?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //1 获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        //2 转换坐标
        convertCoordinateSystem(context: context!)
        
        //3 绘制区域
        let mutablePath = UIBezierPath(rect: rect)
        
        //4 创建需要绘制的文字并设置相应属性
        let mutableAttributeString = settingTextAndAttribute()
        
        //5 为本地图片设置CTRunDelegate，添加占位符
        addCTRunDelegateWith(imageStr: ImageName, indentifier: ImageName, insertIndex: 18,attribute: mutableAttributeString)
        
        //6 为网络图片设置CTRunDelegate
        addCTRunDelegateWith(imageStr: UrlImageName, indentifier: UrlImageName, insertIndex: 35, attribute: mutableAttributeString)
        
        //7 使用mutableAttributeString生成framesetter，使用framesetter生成CTFrame
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttributeString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttributeString.length), mutablePath.cgPath, nil)
        ctFrame = frame
        
        //8 绘制除图片以外的部分
        CTFrameDraw(frame,context!)
        
        //9 处理绘制图片逻辑
        searchImagePosition(frame: frame, context: context!)
    }
    
    
    
    func convertCoordinateSystem(context: CGContext){
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1, y: -1)
        
        // 或者
        //let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty:self.bounds.size.height)
        //CGContextConcatCTM(context, transform)
    }
    
    
    func settingTextAndAttribute()->NSMutableAttributedString{
        let attrString = "人的智慧掌握着三把钥匙，一把开启数字，一把开启字母，一把开启音符。知识、思想、幻想就在其中。人生的价值，并不是用时间，而是用深度去衡量的。人们常觉得准备的阶段是在浪费时间，只有当真正机会来临，而自己没有能力把握的时候，才能觉悟自己平时没有准备才是浪费了时间。"
        
        let mutableAttributeString = NSMutableAttributedString(string: attrString)
        mutableAttributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(0, mutableAttributeString.length))
        mutableAttributeString.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 25),
                                              NSForegroundColorAttributeName:UIColor.red ], range: NSMakeRange(0, 33))
        mutableAttributeString.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 15),NSUnderlineStyleAttributeName: 1], range: NSMakeRange(33,36))
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        style.alignment = .center
        mutableAttributeString.addAttributes([NSParagraphStyleAttributeName:style], range: NSMakeRange(0, mutableAttributeString.length))
        return mutableAttributeString
    }
    
    func addCTRunDelegateWith(imageStr:String, indentifier:String, insertIndex:Int,attribute:NSMutableAttributedString){
        var imageName = imageStr
        var  imageCallback =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
            print("RunDelegate dealloc!")
        }, getAscent: { (refCon) -> CGFloat in
            return 100
        }, getDescent: { (refCon) -> CGFloat in
            return 0
        }) { (refCon) -> CGFloat in
            return 100
        }
        //1:设置CTRun的代理,为图片设置CTRunDelegate,delegate决定留给图片的空间大小
        let runDelegate  = CTRunDelegateCreate(&imageCallback, &imageName)
        //2:空格用于给图片留位置
        let imgString = NSMutableAttributedString(string:" ")
        //3:使用rundelegate占一个位置
        imgString.addAttribute(kCTRunDelegateAttributeName as String, value: runDelegate!, range: NSMakeRange(0, 1))
        //4:添加属性，在CTRun中可以识别出这个字符是图片
        imgString.addAttribute(indentifier, value: imageName, range: NSMakeRange(0, 1))
        //5:在index处插入图片
        attribute.insert(imgString, at: insertIndex)
    }
    
    func searchImagePosition(frame: CTFrame, context: CGContext){
        
        let lines = CTFrameGetLines(frame) as Array
        var originsArray = [CGPoint](repeating: CGPoint.zero, count:lines.count)
        //把frame里每一行的初始坐标写到数组里
        CTFrameGetLineOrigins(frame,CFRangeMake(0, 0),&originsArray)
        
        //遍历每一行CTLine
        for i in 0..<lines.count{
            let line = lines[i]
            var lineAscent = CGFloat(),lineDescent = CGFloat(),lineLeading = CGFloat()
            //该函数除了会设置好ascent,descent,leading之外，还会返回当前行的宽度。
            CTLineGetTypographicBounds(line as! CTLine, &lineAscent, &lineDescent, &lineLeading)
            
            //获取每行中CTRun的个数
            let runs = CTLineGetGlyphRuns(line as! CTLine) as NSArray
            //遍历CTRun找出图片所在的CTRun并进行绘制,每一行可能有多个
            for j in 0..<runs.count{
                var runAscent = CGFloat(),runDescent = CGFloat()
                //获取该行的初始坐标
                let lineOrigin = originsArray[i]
                //获取当前的CTRun
                let run = runs[j]
                //获取CTRun中的属性集
                let attributes = CTRunGetAttributes(run as! CTRun) as NSDictionary
                //获取CTRun的宽度
                let w =  CGFloat(CTRunGetTypographicBounds(run as! CTRun, CFRangeMake(0,0), &runAscent, &runDescent, nil))
                
                //开始计算该CTRun的frame吧,通过CTRunGetTypographicBounds取得宽，ascent和descent
                let range = CTRunGetStringRange(run as! CTRun)
                let offsetX = CTLineGetOffsetForStringIndex(line as! CTLine, range.location, nil)
                let x = lineOrigin.x + offsetX
                let y = lineOrigin.y - runDescent
                let h = runAscent + runDescent
                let  runRect = CGRect.init(x: x, y: y, width: w, height: h)
                //判断CTRunDelegateRef是否存在
                let delegate = attributes.value(forKey: kCTRunDelegateAttributeName as String)
                if  delegate != nil {
                    showImageToContextWith(runRect: runRect, context: context,attributes: attributes)
                }
            }
        }
    }
    
    
    func showImageToContextWith(runRect: CGRect,context: CGContext,attributes:NSDictionary){
        
        let image:UIImage?
        let rect = CGRect.init(x: runRect.minX, y: runRect.minY, width: 100, height: 100)
        let imageDrawRect = rect
        imageFrameArr.add(NSValue(cgRect: imageDrawRect))
        
        if let imageName = attributes.object(forKey: ImageName) as? String {
            //直接绘制本地图片
            if let image = UIImage(named:imageName  as String) {
                context.draw(image.cgImage!, in: imageDrawRect)
            }
        }else if let urlImageName = attributes.object(forKey: UrlImageName) as? String{
            //网络图片的绘制也很简单如果没有下载,使用图占位，然后去下载，下载好了重绘就OK了.
            if self.image == nil{
                image = UIImage(named:"") //灰色图片占位
                if let url = URL.init(string: urlImageName) {
                    let request = NSURLRequest.init(url: url)
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let data = data{
                            DispatchQueue.main.async {
                                self.image = UIImage(data: data)
                                self.setNeedsDisplay()  //下载完成后重绘
                            }
                        }
                    }.resume()
                }
            }else{
                image = self.image
            }
            if let image = image {
                context.draw(image.cgImage!, in: imageDrawRect)
            }
        }
    }
    //MARK:通过touchBegan方法拿到当前点击到的点，响应对应的触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        let touch = touches.first
        let point = touch?.location(in: self)
        if let point = point{
            //检查是否点击在图片上，如果在，优先响应图片事件
            let point = CGPoint.init(x: point.x, y: point.y)
            if self.checkIsClickImageViewWith(point: point) {
                return;
            }
        }
        self.checkIsClickStrWith(point: point!)//响应字符串事件
    }
    
    //MARK:判断是否是点击图片
    func checkIsClickImageViewWith(point: CGPoint) ->Bool{
        for value in imageFrameArr {
            if let value =  value as? NSValue{
                var imageFrame = value.cgRectValue
                //在进行判断之前需要转换图片坐标为UIKit坐标

                imageFrame.origin.y = self.frame.size.height - imageFrame.origin.y - imageFrame.size.height
                if imageFrame.contains(point){
                    print("图片被点击了！")
                    return true
                }
            }
        }
        return false
    }
    
    //MARK:实现获取点击的位置文字
    func checkIsClickStrWith(point: CGPoint){
        
        var location = point
        let lineArr = CTFrameGetLines(ctFrame!)  as NSArray
        let ctLinesArray = lineArr as Array
        var originsArray = [CGPoint](repeating: CGPoint.zero, count:ctLinesArray.count)
        CTFrameGetLineOrigins(ctFrame!, CFRangeMake(0, 0),&originsArray)
        
        for i in 0...CFArrayGetCount(lineArr) {
            let origin = originsArray[i]
            //获取整个CTFrame的大小
            let path = CTFrameGetPath(ctFrame!)
            
            let rect = path.boundingBox
            
            //坐标转换，把每行的原点坐标转换为UIKIt的坐标体系
            let y = rect.origin.y + rect.size.height - origin.y
            
            //判断点击的位置处于那一行范围内
            if location.y <= y && location.x >= origin.x{
                let line = lineArr[i] as! CTLine
                //修改偏移量，找到对应的位置
                location.x -= origin.x
                let index = CTLineGetStringIndexForPosition(line, location)
                print("Click index = \(index)")
                break
            }
        }
    }
}
