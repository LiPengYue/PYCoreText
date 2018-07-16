//
//  PYCoreTextView.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/12.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

protocol PYCoreTextViewDelegate: NSObjectProtocol {
    func getModelType(model: Any) -> PYDataHandler.ModelType
}


class PYCoreTextView: UIView {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
        registerEvent()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - public properties
    var modelArray = [Any]()
    weak var handlerDataSource: PYDataHandlerDataSource?
    // MARK: - public func
    
    // MARK: public network
    func appendData(modelArray: [Any],
                    _ currentModelType: ((_ currentModel: Any) -> (PYDataHandler.ModelType?))?) {
        
    }
    
    func handlerData(modelArray: [Any],
                             _ currentModelType: ((_ currentModel: Any) -> (PYDataHandler.ModelType?))?) {
        /// 缓存获取数据
        //        if getCachDataAndSetupCellData(indexPath: indexPath) { return }
        
        /// 否则去拼接attributedString 并缓存
        if handlerDataSource == nil { return }
        PYDataHandler.handlerData(modelArray: modelArray,handlerDataDelegate: handlerDataSource!,completCallBack: {[weak self] (attributedString, imageModelArray) in
            self?.handlerDataCompletCallBackFunc(attribute: attributedString,
                                                 imgArray: imageModelArray)
            
            
        }) { (model) -> (PYDataHandler.ModelType?) in
            return currentModelType?(model)
        }
    }
    
    ///
    private func handlerDataCompletCallBackFunc(attribute: NSMutableAttributedString,
                                                imgArray: [PYCoreTextImageBaseModel]?) {
            
            let textFrame = createTextFrame(attribute: attribute)
        
        _ = ceratCoreTextDada(textFrame: textFrame,
                                                 imageArray: imgArray,
                                                 cellWidth: 0)
        //upDataCoreTextModelArray(coreTextData: coreTextData)
            textScrollView.reloadData(textFrame: textFrame,
                                      imageModelArray: imgArray)
    }
    
//    /// 是否更新成功
//    private func getCachDataAndSetupCellData(indexPath:IndexPath) -> Bool {
//        var isSetupCellDataSuccess = false
//        let indexString = getIndexString(index: indexPath)
//        if let data = coreTextModelArray[indexString] {
//            if let cell = cellForRow(at: indexPath) as? PYCoreTextTableViewCell {
//
//                if let textFrame = data.textFrame,
//                    let imgArray = data.imageModelArray {
//                    cell.reloadData(cellHeight: data.cellHeight,
//                                    textFrame: textFrame,
//                                    imageModelArray: imgArray)
//
//                    if cell.frame.height < data.cellHeight {
//                        reloadRows(at: [indexPath],
//                                   with: UITableViewRowAnimation.none)
//                    }
//                    isSetupCellDataSuccess = true
//                }
//            }
//        }
//        return isSetupCellDataSuccess
//    }
    
    
    /// 创建 textFrameHandler
    ///
    /// - Parameter attribute: attributedString
    /// - Returns: PYFrameHandler
    func createTextFrame(attribute: NSMutableAttributedString) -> PYFrameHander {
        let inset = UIEdgeInsets.init(top: 0,
                                      left: 0,
                                      bottom: 0,
                                      right: 0)
        let layout = PYFrameHander.Layout.init(//minHeight:view.frame.height,
            maxHeight: frame.height,
            maxWidth: frame.width,
            insets: inset,
            maxStringLenth: nil)
        
        let textFrame = PYFrameHander.init(string: attribute,
                                           layout: layout)
        return textFrame
    }
    
    func ceratCoreTextDada(textFrame: PYFrameHander?,
                           imageArray: [PYCoreTextImageBaseModel]?,
                           cellWidth: CGFloat) -> CoreTextData {
        
        let cellHeight = textFrame?.getAttributedHeight(W: cellWidth) ?? 0
        let coreTextData = CoreTextData.init(textFrame: textFrame,
                                             imageModelArray: imageArray,
                                             cellHeight: cellHeight)
        return coreTextData
    }
//    private func upDataCoreTextModelArray(index: IndexPath,coreTextData: CoreTextData?) {
//        guard let coreTextData = coreTextData else { return }
//        let indexString = getIndexString(index: index)
//        coreTextModelArray.updateValue(coreTextData,
//                                       forKey: indexString)
//    }
    // MARK: - private
    // MARK: - properties
    
    // MARK: - func
    
    // MARK: network
    
    // MARK: handle views
    
    ///设置
    private func setup() {
        addSubview(textScrollView)
        textScrollView.translatesAutoresizingMaskIntoConstraints = false
        textScrollView.layoutSuperViewEdges()
        textScrollView.layoutHeightEqutoSuperView()
        textScrollView.layoutWidthEqutoSuperView()
    }
    // MARK: handle event
    ///事件
    private func registerEvent() {
        
    }
    
    // MARK:functions
    
    // MARK:life cycles
    
    // MARK: lazy loads
    let textScrollView = PYTextScrollView()
    deinit {
        RunLoopManager.defult.isCloseLoopManager = true
        RunLoopManager.defult.deleteAllTask()
    }
}

extension PYCoreTextView {
    struct CoreTextData {
        var textFrame: PYFrameHander?
        var imageModelArray: [PYCoreTextImageBaseModel]?
        var cellHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    }
}
