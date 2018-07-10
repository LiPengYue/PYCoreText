//
//  PYCoreTextTableView.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/10.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

protocol PYCoreTextTableViewProtocol: NSObjectProtocol {
    func getModelType(model: Any) -> PYDataHandler.ModelType
}


class PYCoreTextTableView: UITableView,UITableViewDelegate,UITableViewDataSource,PYDataHandlerCompleteDelegate {
 
    
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
    weak var handlerDataDelegate: PYDataHandlerDelegate?
    weak var coreTextTableViewProtocol: PYCoreTextTableViewProtocol?
    
    var modelArray = [Any]() {
        didSet {
            reloadData()
        }
    }
    
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
    
    // MARK:life cycles
    
    // MARK: lazy loads
}

extension PYCoreTextTableView {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let cell = cell as? PYCoreTextTableViewCell {
            
            if let delegate = handlerDataDelegate {
                PYDataHandler.handlerData(modelArray: modelArray, handlerDataDelegate: delegate, completCallBack: { [weak tableView, weak self] (attribute, imgArray) in
//                    let cell = tableView?.cellForRow(at: indexPath)
                    if let cell = cell as? PYCoreTextTableViewCell {
                        let inset = UIEdgeInsets.init(top: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      right: 0)
                        let layout = PYFrameHander.Layout.init(//minHeight:view.frame.height,
                            maxHeight: self?.frame.height ?? 0,
                            maxWidth: self?.frame.width ?? 0,
                            insets: inset,
                            maxStringLenth: nil)
                        let textFrame = PYFrameHander.init(string: attribute, layout: layout)
                        cell.reloadData(textFrame: textFrame, imageModelArray: imgArray)
                    }
                }) {[weak self] (data) -> (PYDataHandler.ModelType?) in
                    return self?.coreTextTableViewProtocol?.getModelType(model: data)
                }
            }
        }
        return cell
    }
}

extension PYCoreTextTableView {
    
    func completed(attribute: NSMutableAttributedString, imageModelArray: [PYCoreTextImageBaseModel]) {
        
    }
    
}
