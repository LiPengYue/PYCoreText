//
//  PYCoreTextStringModel.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/3.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit


/// textModel
class PYCoreTextStringBaseModel: NSObject {
    
    override init() { super.init() }
    
    /// 字符
    var string: String?
    /// 设置字符串
    var attributeHandler: PYAttributedHandler?
}
