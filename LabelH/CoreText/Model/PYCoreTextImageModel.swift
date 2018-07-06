//
//  PYCoreTextImageModel.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/6/25.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

 ///CTRunDelegateCallbacks回调结构体，告诉代理该回调那些方法。我们绘制图片的时候实际上是在一个CTRun中绘制这个图片，那么CTRun绘制的坐标系中，会以origin点作为原点进行绘制。基线为过原点的x轴，ascent即为CTRun顶线距基线的距离，descent即为底线距基线的距离。我们通过代理设置CTRun的尺寸间接设置图片的尺寸，这里暂时使用默认数据。
/// https://blog.csdn.net/longshihua/article/details/52105091


class PYCoreTextImageBaseModel: NSObject {
    var url: String?
    var frame: CGRect {
        return framePrivate
    }
   
    /// CTRun顶线距基线的距离
    var ascent: CGFloat = 100
    /// descent即为底线距基线的距离
    var descent: CGFloat = 0
    var width: CGFloat = 0
    var lineSpace: CGFloat = 8.0

    
    // MARK: - private
    /// 设置字符串
    var attributeHandler: PYAttributedHandler?
    override init() { super.init() }
    @objc var framePrivate: CGRect = .zero
}
