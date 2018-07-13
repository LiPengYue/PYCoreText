//
//  PYCoreTextTableView.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/10.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

protocol PYCoreTextTableViewDelegate: NSObjectProtocol {
    func getModelType(model: Any) -> PYDataHandler.ModelType
}


class PYCoreTextTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - init
    let cellID = "CellID"
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - properties
    weak var handlerDataDelegate: PYDataHandlerDataSource?
    weak var coreTextTableViewDelegate: PYCoreTextTableViewDelegate?
    
    var modelArray = [Any]() {
        didSet {
            reloadData()
        }
    }
    /// 用于缓存数据的数组
    var coreText = [String:CoreTextData]()
    private var coreTextModelArray:[String:CoreTextData] = [String:CoreTextData]()
    
   
    
    // MARK: - func
    private func setup() {
        delegate = self
        dataSource = self
        tableFooterView = UIView()
        estimatedRowHeight = 200
        rowHeight = UITableViewAutomaticDimension
        register(PYCoreTextTableViewCell.self,
                 forCellReuseIdentifier: cellID)
    }
    
    // MARK: network
    
    // MARK: handle views
    
    // MARK: handle event
    
    // MARK:functions
    func setupCellData(indexPath: IndexPath,
                       delegate: PYDataHandlerDataSource?) {
        /// 缓存获取数据
//        if getCachDataAndSetupCellData(indexPath: indexPath) { return }
        
        /// 否则去拼接attributedString 并缓存
        if delegate == nil { return }
        PYDataHandler.handlerData(modelArray: modelArray, handlerDataDelegate: delegate!, completCallBack: { [weak self] (attribute, imgArray) in
            self?.handlerDataCompletCallBackFunc(indexPath: indexPath,
                                                 attribute: attribute,
                                                 imgArray: imgArray)
            
        }) {[weak self] (data) -> (PYDataHandler.ModelType?) in
            return self?.coreTextTableViewDelegate?.getModelType(model: data)
        }
    }
    
    ///
    private func handlerDataCompletCallBackFunc(indexPath: IndexPath,
                                                attribute: NSMutableAttributedString,
                                                imgArray: [PYCoreTextImageBaseModel]?) {
        let cell = cellForRow(at: indexPath)
        
        if let cell = cell as? PYCoreTextTableViewCell {
            
            let textFrame = createTextFrame(attribute: attribute)
            let cellW = cell.frame.width
            let coreTextData = ceratCoreTextDada(textFrame: textFrame,
                                                 imageArray: imgArray,
                                                 cellWidth: cellW)
            upDataCoreTextModelArray(index: indexPath,
                                          coreTextData: coreTextData)
            cell.reloadData(cellHeight: coreTextData.cellHeight,
                            textFrame: textFrame,
                            imageModelArray: imgArray)
//            cell.reloadData(textFrame: textFrame,
//                            imageModelArray: imgArray)
            
            if cell.frame.height < coreTextData.cellHeight {
//                reloadRows(at: [indexPath],
//                           with: UITableViewRowAnimation.none)
            }
        }
    }
    
    /// 是否更新成功
    private func getCachDataAndSetupCellData(indexPath:IndexPath) -> Bool {
        var isSetupCellDataSuccess = false
        let indexString = getIndexString(index: indexPath)
        if let data = coreTextModelArray[indexString] {
            if let cell = cellForRow(at: indexPath) as? PYCoreTextTableViewCell {
                
                if let textFrame = data.textFrame,
                    let imgArray = data.imageModelArray {
                    cell.reloadData(cellHeight: data.cellHeight,
                                    textFrame: textFrame,
                                    imageModelArray: imgArray)
                    
                    if cell.frame.height < data.cellHeight {
                        reloadRows(at: [indexPath],
                                   with: UITableViewRowAnimation.none)
                    }
                    isSetupCellDataSuccess = true
                }
            }
        }
        return isSetupCellDataSuccess
    }
    
    func getIndexString(index:IndexPath) -> String {
        return NSStringFromClass(self.classForCoder) + "\(index.section)-\(index.row)"
    }
    
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
    
    private func upDataCoreTextModelArray(index: IndexPath,coreTextData: CoreTextData?) {
        guard let coreTextData = coreTextData else { return }
        let indexString = getIndexString(index: index)
        coreTextModelArray.updateValue(coreTextData,
                                       forKey: indexString)
    }
    // MARK:life cycles
    
    // MARK: lazy loads
}

extension PYCoreTextTableView {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        setupCellData(indexPath: indexPath, delegate: handlerDataDelegate)
        return cell
    }
}


extension PYCoreTextTableView {
    struct CoreTextData {
        var textFrame: PYFrameHander?
        var imageModelArray: [PYCoreTextImageBaseModel]?
        var cellHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    }
}
private extension PYCoreTextTableView {
   
   
    
  
}
