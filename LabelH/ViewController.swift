//
//  ViewController.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/15.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//https://www.2cto.com/kf/201609/546492.html

import UIKit
import SnapKit

class ViewController: UIViewController,PYDataHandlerDataSource,PYCoreTextTableViewDelegate {
 
  
  
    
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
//        handler.verticalForms = true
        return handler
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        coreText()
        setupTextScrollView()
//       setupTableView()
    }
    
    func setupTextScrollView() {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickButton), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        button.backgroundColor = UIColor.blue
        button.setTitle("button", for: UIControlState.normal)
        button.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(100)
        }
        
        view.addSubview(coreTextView)
        coreTextView.handlerDataSource = self
        coreTextView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(button.snp.bottom)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.coreTextTableViewDelegate = self as! PYCoreTextTableViewDelegate
        tableView.handlerDataDelegate = self
        
        let button = UIButton()
        button.addTarget(self, action: #selector(clickButton), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        button.backgroundColor = UIColor.blue
        button.setTitle("button", for: UIControlState.normal)
        button.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(200)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(button.snp.bottom)
        }
    }
    
    @objc private func clickButton() {
        let model1 = ImageModel.init()
        let model2 = TextModel.init()
        var modelArray1 = [Any]()
        var modelArray2 = [Any]()
//        for _ in 0 ..< 122 {
//            modelArray1.append(model1)
//            modelArray1.append(model2)
//        }
        for _ in 0 ..< 1 {
//            modelArray2.append(model1)
            modelArray2.append(model2)
        }
//        tableView.modelArray = modelArray2
        coreTextView.modelArray = modelArray2
        coreTextView.handlerData(modelArray: modelArray2) { (model) -> (PYDataHandler.ModelType?) in
            if model is TextModel { return .text }
            if model is ImageModel { return .image }
            return .text
        }
    }
    
    
    // MARK: - tableView
    lazy var tableView: PYCoreTextTableView = {
       let tableView = PYCoreTextTableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        return tableView
    }()
    
    lazy var coreTextView = PYCoreTextView()
    
    
    func coreText() {

        textView.frame = view.bounds
        textView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        textView.isAutoLayoutSize = true
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(view.frame.height)
            make.top.equalTo(view)
            make.width.equalTo(view.frame.width)
        }
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let model1 = ImageModel.init()
        let model2 = TextModel.init()
        var modelArray2 = [Any]()
        for _ in 0 ..< 11 {
            modelArray2.append(model1)
            modelArray2.append(model2)
        }
//        PYDataHandler.handlerData(modelArray: modelArray2, handlerDataDelegate: self) { (model) -> (PYDataHandler.ModelType) in
//            if model is TextModel { return .text }
//            if model is ImageModel { return .image }
//            return .text
//        }
    }
}


//MARK: - PYDataHandler delegate
extension ViewController {
    
    
    func createLinkModel(model: Any) -> PYCoreLinkBaseModel {
        return PYCoreLinkBaseModel()
    }
    
    func createTextModel(model: Any) -> PYCoreTextStringBaseModel {
        let textModel = PYCoreTextStringBaseModel.init()
        
        let handler = self.attributeHandler.py_copy()
        let style = NSMutableParagraphStyle()
        
        switch Int(arc4random_uniform(3)) {
        case 0:
            style.alignment = .left
        case 1:
            style.alignment = .center
        case 2:
            style.alignment = .right
        default: style.alignment = .right
        }
        handler.paragraphStyle = style
        
        if let model = model as? TextModel {
            handler.foregroundColor = model.textColor
            handler.text = model.str
            handler.font = PYAttributedHandler.Font(size: 32)
        }
        
        textModel.attributeHandler = handler
        return textModel
    }
    
    func createImageModel(model: Any) -> PYCoreTextImageBaseModel {
        
        guard let model = model as? ImageModel else {
            return PYCoreTextImageBaseModel()
        }
        
        let imageModel = PYCoreTextImageBaseModel.init()
        imageModel.ascent = model.bounds?.height ?? 0
        imageModel.width = model.bounds?.width ?? 0
        imageModel.url = model.url ?? ""
        let handler = self.attributeHandler.py_copy()
        let style = NSMutableParagraphStyle()

        switch Int(arc4random_uniform(3)) {
        case 0:
            style.alignment = .left
        case 1:
            style.alignment = .center
        case 2:
            style.alignment = .right
        default: style.alignment = .right
        }
        
        handler.paragraphStyle = style
        imageModel.attributeHandler = handler
        return imageModel
    }
    
    func completed(attribute: NSMutableAttributedString, imageModelArray: [PYCoreTextImageBaseModel]) {
        let inset = UIEdgeInsets.init(top: 0,
                                      left: 0,
                                      bottom: 0,
                                      right: 0)
        let layout = PYFrameHander.Layout.init(//minHeight:view.frame.height,
            maxHeight: view.frame.height,
            maxWidth: view.frame.width,
            insets: inset,
            maxStringLenth: nil)
        let pyFrame = PYFrameHander.init(string: attribute, layout: layout)
        
        
        textView.imageModelArray = imageModelArray
                textView.attributedString = attribute
        textView.textFrame = pyFrame
        let size = CGSize.init(width: pyFrame.attributedMaxSize.width, height: pyFrame.attributedMaxSize.height)
                textView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: size)
//        textView.snp.updateConstraints { (make) in
//            //            make.height.equalTo(size.height)
//            //            make.width.equalTo(size.width)
//        }
    }
    
}


//MARK: - TextView delegate
extension ViewController {
    func getModelType(model: Any) -> PYDataHandler.ModelType {
        if model is TextModel { return .text }
        if model is ImageModel { return .image }
        return .text
    }
}

