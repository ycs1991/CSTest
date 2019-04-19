//
//  CSNodeModel.swift
//  MostLevelTableViewCell
//
//  Created by changsheng yu on 2019/4/18.
//  Copyright © 2019 changsheng yu. All rights reserved.
//

import UIKit

class CSNodeModel: NSObject {
    var parentID: String = ""  //父节点id, 当前节点的父节点id
    var childrenID: String = ""  //子节点id, 当前节点id
    var nodeName: String = ""  //节点名字
    var level: Int = 1        //节点层级，从1层开始
    var isLeaf: Bool = false    //默认false ， 如果是true 则此节点下边没有节点
    var isRoot: Bool = true    //默认true ， 如果是true 则父节点为nil
    var isExpand: Bool = false  //是否展开
    var isSelected: Bool = false  //是否选中

}
