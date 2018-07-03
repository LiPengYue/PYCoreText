//
//  ViewController.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/15.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//https://www.2cto.com/kf/201609/546492.html

import UIKit
import SnapKit

class ViewController: UIViewController,PYDataHandlerDelegate {
    func getAttributedHandler() -> (PYAttributedHandler) {
        return attributeHandler
    }
    func completed(attribute: NSMutableAttributedString, imageModelArray: [PYCoreTextImageBaseModel]) {
        let inset = UIEdgeInsets.init(top: 50, left: 0, bottom: 0, right: 0)
        let layout = PYFrameHander.Layout.init(//minHeight:view.frame.height,
                                               maxHeight: view.frame.height,
                                               maxWidth: view.frame.width,
                                               insets: inset,
                                               maxStringLenth: nil)
        let pyFrame = PYFrameHander.init(string: attribute, layout: layout)
        textView.imageModelArray = imageModelArray
//        textView.attributedString = attribute
        textView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: pyFrame.attributedMaxSize)
        textView.textFrame = pyFrame
    }
    
    func createImageModel(model: Any) -> PYCoreTextImageBaseModel {
        
        guard let model = model as? Model else {
            return PYCoreTextImageBaseModel()
        }
        
        let imageModel = PYCoreTextImageBaseModel.init()
        imageModel.ascent = model.bounds?.height ?? 0
        imageModel.width = model.bounds?.width ?? 0
        imageModel.url = model.url ?? ""
        return imageModel
    }
  
    
    let label = UILabel()
    var number = 4
    let frameLabel = UILabel()
    let textView = PYTextView.init()
    
//    var str = "fl不知道你是不是不方便就不要再有一次不联系也不是什么好消息好么……😄这里也很好吃。我的人生真的太多人和爱过的一样。我的手机号码都是从手机号码里发出来hahahahahha方便就不要再有一次不联系也不是什么好消息好么……这里也很好吃。我的人生真的太多人和爱过的一样。我的手机号码都是从手机号号码都是从手机号码里发出来ha"
//    var str = "HAaa..>≥≥øˆ¨¥††©©∆˜˜©ƒ†¥˚¨©¬˚©ÍÏÒ˚√ßƒ¬ˆ¨©œ∑ˆ¨∆˚😄》。。。。"
    var str = "不"
    var attributeHandler: PYAttributedHandler {
        let handler = PYAttributedHandler.init()
        handler.font = PYAttributedHandler.Font(name: "PingFangSC-Regular", size: 30, affineTransform: nil)
        handler.text = str
        handler.characterSpacing = 0
        handler.ligature = 0
        handler.foregroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        handler.foregroundColorFromContext = true
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        //            style.firstLineHeadIndent = 1
        //            style.headIndent = 1
        //            style.lineHeightMultiple = 1
//        style.maximumLineHeight = 100
//        style.minimumLineHeight = 10
        //            style.lineSpacing = 1
//                    style.tailIndent = 3
        
        handler.paragraphStyle = style
        handler.strokeWidth = 3
        handler.strokeColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        handler.superscript = 3
        handler.underlineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        handler.underlineStyle = PYAttributedHandler.LineStyle.single
        handler.underlineStyleModifiers = PYAttributedHandler.LineStyleModifiers.patternDot
        handler.textBackgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        handler.strikethroughStyle = PYAttributedHandler.LineStyle.single
        handler.strikethroughColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        handler.baselineOffset = 0
        handler.verticalForms = true
        return handler
    }
    var strAttributed: NSMutableAttributedString {
        get {
            let handler = PYAttributedHandler.init()
            handler.font = PYAttributedHandler.Font(name: "PingFangSC-Regular", size: 30, affineTransform: nil)
            handler.text = str
            handler.characterSpacing = 0
            handler.ligature = 0
            handler.foregroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            handler.foregroundColorFromContext = true
            
            let style = NSMutableParagraphStyle()
            style.alignment = .center
//            style.firstLineHeadIndent = 1
//            style.headIndent = 1
//            style.lineHeightMultiple = 1
            style.maximumLineHeight = 100
            style.minimumLineHeight = 10
            style.lineSpacing = 10
//            style.tailIndent = 3

            handler.paragraphStyle = style
            handler.strokeWidth = 3
            handler.strokeColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            handler.superscript = 3
            handler.underlineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            handler.underlineStyle = PYAttributedHandler.LineStyle.single
            handler.underlineStyleModifiers = PYAttributedHandler.LineStyleModifiers.patternDot
            handler.textBackgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            handler.strikethroughStyle = PYAttributedHandler.LineStyle.single
            handler.strikethroughColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            handler.baselineOffset = 0
//            handler.verticalForms = true
            return handler.createMutableAttributedStringIfExsitStr()!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        coreText()
//        let tempView = PYCoreTextTemp()
//        tempView.frame = view.bounds
//        view.addSubview(tempView)
    }

    func coreText() {
//        textView.frame = CGRect.init(x: 0, y: 20, width: 400, height: 300)
        textView.frame = view.bounds
        textView.backgroundColor = UIColor.red
//        let insets = UIEdgeInsets.init(top: 110, left: 40, bottom: 30, right: 40)
//        let frame = PYFrameHander.init(string: strAttributed)
        textView.isAutoLayoutSize = true
//        textView.textMaxSize = CGSize.init(width: 300, height: CGFloat.greatestFiniteMagnitude)
//        textView.textFrame = frame
        view.addSubview(textView)
//        textView.frame = CGRect.init(origin: CGPoint.zero, size: frame.attributedMaxSize)
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        str += "号"
//        let insert = UIEdgeInsets.init(top: 50, left: 10, bottom: 10, right: 10)
//        let layout = PYFrameHander.Layout.init(//minHeight: view.frame.height,
//                                               maxHeight: 400,
//                                               //minWidth: view.frame.width,
//                                               maxWidth: view.frame.width,
//                                               insets: insert,//UIEdgeInsets.zero,
//                                               maxStringLenth: nil)
//        let frame = PYFrameHander.init(string: strAttributed, layout: layout)
//        textView.isAutoLayoutSize = true
//        textView.textFrame = frame
//        textView.frame = CGRect.init(origin: CGPoint.init(x: 10, y: 50), size: frame.attributedMaxSize)
        
        
        let model1 = Model.init()
        let model2 = Model.init()
        let modelArray = [
            model1//,model2,model1,model2,model1,model2,model1,model2
        ]
        PYDataHandler.handlerData(modelArray: modelArray, datagate: self) { (model) -> (PYDataHandler.ModelType) in
            return .image
        }
    }
    
    
}
