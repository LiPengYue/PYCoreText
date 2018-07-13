//
//  TextModel.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/3.
//  Copyright © 2018年 李鹏跃. All rights reserved.
import UIKit
class TextModel: NSObject {
    var str: String {
        var str = ""
        for _ in 0 ..< 63 {
            str += "\n哈,哈哈哈哈哈哈哈哈哈?\n"
        }
        return str
    }
    var textColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
}
