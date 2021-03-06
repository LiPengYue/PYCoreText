//
//  PYDataHandler.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/28.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit
//http://www.code4app.com/thread-27079-1-1.html
//https://www.raywenderlich.com/153591/core-text-tutorial-ios-making-magazine-app
///https://www.jianshu.com/p/e52a38e60e7c
let k_PYCoreTextImage =  "k_PYCoreTextImageIsImagePosition"

protocol PYDataHandlerCompleteDelegate {
    /// 数据处理完成
    ///
    /// - Parameters:
    ///   - attribute: attributedString
    ///   - imageModelArray: imageModelArray
    func completed(attribute: NSMutableAttributedString,
                   imageModelArray: [PYCoreTextImageBaseModel])
}

@objc protocol PYDataHandlerDataSource {
    
    /// 创建string 中的image 模型
    ///
    /// - Parameter model: 网络数据模型
    /// - Returns: 返回数据模型
    func createImageModel(model:Any) -> PYCoreTextImageBaseModel
    
    
    /// 创建textModel
    ///
    /// - Parameter model: 网络模型
    /// - Returns: 返回数据模型
    func createTextModel(model:Any) -> PYCoreTextStringBaseModel
    
    
    /// 创建LinkModel
    ///
    /// - Parameter model: 网络模型
    /// - Returns: 返回数据模型
    func createLinkModel(model:Any) -> PYCoreLinkBaseModel
}


class PYDataHandler: NSObject {
    
    /// 数据的处理 block 回调
    ///
    /// - Parameters:
    ///   - modelArray: 数据集合
    ///   - imageDatagate:
    ///   - currentModelType: 需要返回对应的类型
    class func handlerData(modelArray:[Any],
                              handlerDataDelegate: PYDataHandlerDataSource,
                              completCallBack: ((_ attribute: NSMutableAttributedString,
        _ imageModelArray: [PYCoreTextImageBaseModel])->())?,
                              _ currentModelType: ((_ currentModel: Any) -> (ModelType?))?) {
        handlerModelArray(modelArray: modelArray,handlerDataDelegate: handlerDataDelegate,{ (data) -> (PYDataHandler.ModelType?) in
            return currentModelType?(data)
        }) { (string, imageModelArray) in
            completCallBack?(string,imageModelArray)
        }
        
    }
    
    /// 数据的处理 delegate 回调
    ///
    /// - Parameters:
    ///   - modelArray: 数据集合
    ///   - imageDatagate:
    ///   - currentModelType: 需要返回对应的类型
    class func handlerData(modelArray:[Any],
                              handlerDataDelegate: PYDataHandlerDataSource,
                              _ completDelegate:PYDataHandlerCompleteDelegate? = nil,
                              _ currentModelType:@escaping ((_ currentModel: Any) -> (ModelType?))) {
        
        handlerModelArray(modelArray: modelArray, handlerDataDelegate: handlerDataDelegate,{ (data) -> (PYDataHandler.ModelType?) in
            return currentModelType(data)
        }) { (string, imageModelArray) in
            completDelegate?.completed(attribute: string,
                                       imageModelArray: imageModelArray)
        }
    }
    
    private class func handlerModelArray(modelArray:[Any],
                                            handlerDataDelegate: PYDataHandlerDataSource,
                                            _ currentModelType:@escaping ((_ currentModel: Any) -> (ModelType?)),
                                            _ complete:((_ str: NSMutableAttributedString, _ imageModelArray:[PYCoreTextImageBaseModel])->())?){
        
        let attributedStringM = NSMutableAttributedString()
        var imageBaseModeArrayM = [PYCoreTextImageBaseModel]()
            
        for model in modelArray {
            RunLoopManager.defult.addTask {
                let type = currentModelType(model)
                switch type {
                case .image?:
                    let result = handlerImageData(model: model,
                                                  imageDelegate: handlerDataDelegate)
                    attributedStringM.append(result.0)
                    imageBaseModeArrayM.append(result.1)
                case .link?:
                    let result = handleLink(model: model, textDelegate: handlerDataDelegate)
                    attributedStringM.append(result)
                case .text?:
                    let attribted = handleText(model: model,
                                               textDelegate: handlerDataDelegate)
                    attributedStringM.append(attribted)
                default: break
                }
            }
        }
        RunLoopManager.defult.completeFunc {
            complete?(attributedStringM,imageBaseModeArrayM)
        }
    
    }
    
    
    /// 处理text
    ///
    /// - Parameters:
    ///   - model: 网络数据模型
    ///   - textDelegate: delegate
    /// - Returns: 返回 attributed
    private class func handleText<T>(model: T, textDelegate: PYDataHandlerDataSource) -> NSMutableAttributedString {
        
        let textModel = textDelegate.createTextModel(model: model)
        
        let handler = textModel.attributeHandler
        //        handler?.text = textModel.string ?? textModel.
        let attri = handler?.createMutableAttributedStringIfExsitStr()
        return attri ?? NSMutableAttributedString(string: "")
    }
    
    private class func handleLink<T>(model: T, textDelegate: PYDataHandlerDataSource) -> NSMutableAttributedString {
        let linkModel = textDelegate.createLinkModel(model: model)
        let handler = linkModel.attributeHandler
        let attri = handler?.createMutableAttributedStringIfExsitStr()
        return attri ?? NSMutableAttributedString(string: "")
    }
    
    /// 处理image
    ///
    /// - Parameters:
    ///   - model: 网络数据的model model
    ///   - imageDelegate: imageDelegate
    /// - Returns: 处理后的image站位字符
    private class func handlerImageData<T>(model:T,imageDelegate: PYDataHandlerDataSource) -> (NSMutableAttributedString,PYCoreTextImageBaseModel){
        
        let imageModel = imageDelegate.createImageModel(model: model)
        
        let extentBuffer = UnsafeMutablePointer<RunStruct>.allocate(capacity: 1)
        
        let runStruct = RunStruct.init(ascent: imageModel.ascent,
                                       descent: imageModel.descent,
                                       width: imageModel.width)
        
        extentBuffer.initialize(to: runStruct)
        
        var imageCallback = CTRunDelegateCallbacks.init(version: kCTRunDelegateVersion1, dealloc: { (REFCON) in
            print("\n✅ Run Delegate dealloc!!!\n")
            
        }, getAscent: { (pointer) -> CGFloat in
            let runStruct = pointer.assumingMemoryBound(to: RunStruct.self)
            return runStruct.pointee.ascent
            
        }, getDescent: { (pointer) -> CGFloat in
            let runStruct = pointer.assumingMemoryBound(to: RunStruct.self)
            return runStruct.pointee.descent
            
        }) { (pointer) -> CGFloat in
            let imageModel = pointer.assumingMemoryBound(to: RunStruct.self)
            return imageModel.pointee.width
        }
        
        let runDelegate = CTRunDelegateCreate(&imageCallback,
                                              extentBuffer)
        
        let attributed = createAttribute(string: "o",
                                         attributedHandler: imageModel.attributeHandler)
        
        let cfRange = CFRange.init(location: 0,
                                   length: attributed.length)
        
        CFAttributedStringSetAttribute(attributed,
                                       cfRange, kCTRunDelegateAttributeName,
                                       runDelegate)
        
        return (attributed,imageModel)
    }
    
    private class func createAttribute(string: String, attributedHandler: PYAttributedHandler?) -> NSMutableAttributedString {
        
        var attri: NSMutableAttributedString?
        if let attributedHandelr = attributedHandler {
            attributedHandelr.textBackgroundColor = nil
            attributedHandelr.foregroundColor = .clear
            attributedHandelr.strokeColor = nil
            attributedHandelr.underlineColor = nil
            attributedHandelr.shadowColor = nil
            attributedHandelr.strikethroughColor = nil
            attributedHandelr.text = string
            attri = attributedHandelr.createMutableAttributedStringIfExsitStr()
        }
        if attri == nil {
            attri = NSMutableAttributedString(string: string)
        }
        let range = NSRange.init(location: 0, length: attri?.length ?? 0)
        
        attri?.addAttribute(k_PYCoreTextImage, value: k_PYCoreTextImage, range: range)
        return attri!
    }
}


extension PYDataHandler {
    enum ModelType: NSInteger {
        case image = 11
        case link = 12
        case text = 13
    }
    
    struct RunStruct {
        let ascent: CGFloat
        let descent: CGFloat
        let width: CGFloat
    }
}
