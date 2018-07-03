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

@objc protocol PYDataHandlerDelegate {
    func getAttributedHandler() -> (PYAttributedHandler) 
    
    /// 创建string 中的image 模型
    ///
    /// - Parameter model: 网络数据模型
    /// - Returns: 返回数据模型
    func createImageModel(model:Any) -> PYCoreTextImageBaseModel
    
    
    /// 处理图片的attributeString
    ///
    /// - Parameter attributes: 需要添加的属性
    @objc optional func setupImageAttributeSting(attributes: [String:Any])
    
    func completed(attribute: NSMutableAttributedString, imageModelArray: [PYCoreTextImageBaseModel])
}


class PYDataHandler: NSObject {
    
    /// 数据的处理
    ///
    /// - Parameters:
    ///   - modelArray: 数据集合
    ///   - imageDatagate:
    ///   - currentModelType: 需要返回对应的类型
    class func handlerData<T>(modelArray:[T], datagate: PYDataHandlerDelegate,_ currentModelType:((_ currentModel: T) -> (ModelType))) {
        let attributedStringM = NSMutableAttributedString()
        var imageBaseModeArrayM = [PYCoreTextImageBaseModel]()
        for model in modelArray {
            let type = currentModelType(model)
            switch type {
            case .image:
                let result = self.handlerImageData(model: model, imageDelegate: datagate)
                attributedStringM.append(result.0)
                imageBaseModeArrayM.append(result.1)
            case .link:
                break
            case .text:
                break
            }
        }
      
        datagate.completed(attribute: attributedStringM, imageModelArray: imageBaseModeArrayM)
    }
    
    class func handlerImageData<T>(model:T, imageDelegate: PYDataHandlerDelegate) -> (NSMutableAttributedString,PYCoreTextImageBaseModel) {
        let imageModel = imageDelegate.createImageModel(model: model)
        
        let extentBuffer = UnsafeMutablePointer<RunStruct>.allocate(capacity: 1)
        let runStruct = RunStruct.init(ascent: imageModel.ascent, descent: imageModel.descent, width: imageModel.width)
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
        
        let runDelegate = CTRunDelegateCreate(&imageCallback, extentBuffer)
        /// 生成NSAttributedString
        var attributedHandelr = imageDelegate.getAttributedHandler()
        attributedHandelr = attributedHandelr.py_copy()

        attributedHandelr.textBackgroundColor = nil
        attributedHandelr.foregroundColor = .clear
        attributedHandelr.strokeColor = nil
        attributedHandelr.underlineColor = nil
        attributedHandelr.shadowColor = nil
        attributedHandelr.strikethroughColor = nil
        attributedHandelr.text = "0"
        
        let attri = attributedHandelr.createMutableAttributedStringIfExsitStr()
        let range = NSRange.init(location: 0, length: attri?.length ?? 0)
        let cfRange = CFRange.init(location: 0, length: attri?.length ?? 0)
        CFAttributedStringSetAttribute(attri, cfRange, kCTRunDelegateAttributeName, runDelegate)
        
        attri?.addAttribute(k_PYCoreTextImage, value: k_PYCoreTextImage, range: range)
        let attributed = attri
        
        return (attributed!,imageModel)
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
