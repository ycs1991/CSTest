//
//  MainViewController.swift
//  MostLevelTableViewCell
//
//  Created by changsheng yu on 2019/4/18.
//  Copyright © 2019 changsheng yu. All rights reserved.
//

import UIKit
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
class MainViewController: UIViewController {

    //最大的层级数
    let maxLevel = 4
    let cellIdentifier = "CSNodeTableViewCell"
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(CSNodeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return table
    }()
    lazy var dataSource = NSMutableArray()
    lazy var selectedSource = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TableView多级列表分布"
        view.addSubview(tableView)
        setDataSource()
    }
    
    // MARK: - 初始化数据，节点数组
    func setDataSource() {
        for _ in 0...4 {
            let nodeModel = CSNodeModel()
            nodeModel.nodeName = String.init(format: "第%d级节点", nodeModel.level)
            dataSource.add(nodeModel)
        }
    }
    // MARK: - 展开父节点
    func expandChildNodes(level: Int, at indexPath: NSIndexPath) {
        let nodeModel: CSNodeModel = dataSource[indexPath.row] as! CSNodeModel
        let insertNodeArray = NSMutableArray()
        let insertLocation: Int = indexPath.row + 1
        for i in 0..<arc4random()%9 {
            let node = CSNodeModel()
            node.parentID = ""
            node.childrenID = ""
            node.level = level + 1
            node.nodeName = String.init(format: "第%d级节点", node.level)
            node.isLeaf = nodeModel.level < maxLevel ? false : true
            node.isRoot = false
            node.isExpand = false
            node.isSelected = nodeModel.isSelected
            dataSource.insert(node, at: insertLocation + Int(i))
            insertNodeArray.add(NSIndexPath.init(row: insertLocation + Int(i), section: 0))
        }
        //插入cell
        tableView.beginUpdates()
        tableView.insertRows(at: NSArray.init(array: insertNodeArray) as! [IndexPath], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
        //更新所有cell的cellIndexPath
        let reloadAllRowsArray = NSMutableArray()
        let reloadLocation = insertLocation + insertNodeArray.count
        for i in reloadLocation..<dataSource.count {
            reloadAllRowsArray.add(NSIndexPath.init(row: i, section: 0))
        }
        tableView.reloadRows(at: reloadAllRowsArray as! [IndexPath], with: UITableView.RowAnimation.none)
    }
    
    // MARK: - 获取并隐藏父节点的子节点数组
    func hiddenChildNodes(level: Int, at indexPath: NSIndexPath) {
        let deleteNodeRowsArray = NSMutableArray()
        var length: Int = 0
        let deleteLocation = indexPath.row + 1
        for i in deleteLocation..<dataSource.count {
            let node: CSNodeModel = dataSource[i] as! CSNodeModel
            if (node.level > level) {
                deleteNodeRowsArray.add(NSIndexPath.init(row: i, section: 0))
                length += 1
            }else {
                break
            }
        }
        dataSource.removeObjects(in: NSMakeRange(deleteLocation, length))
        tableView.beginUpdates()
        tableView.deleteRows(at: deleteNodeRowsArray as! [IndexPath], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
        
        //更新删除所有的cellh的cellIndexPath
        let reloadRowsArray = NSMutableArray()
        let reloadLocation = deleteLocation
        for i in reloadLocation..<dataSource.count {
            reloadRowsArray.add(NSIndexPath.init(row: i, section: 0))
        }
        tableView.reloadRows(at: reloadRowsArray as! [IndexPath], with: UITableView.RowAnimation.none)
    }
    
    //更新当前节点下所有子节点的选中状态
    func selectedChildNodes(level: Int, isSelected: Bool, at indexPath: NSIndexPath) {
        let selectedNodeRowsArray = NSMutableArray()
        let deleteLocation = indexPath.row + 1
        for i in deleteLocation..<dataSource.count {
            let node: CSNodeModel = dataSource[i] as! CSNodeModel
            if node.level > level {
                node.isSelected = isSelected
                selectedNodeRowsArray.add(NSIndexPath.init(row: i, section: 0))
            }else {
                break
            }
        }
        tableView.reloadRows(at: selectedNodeRowsArray as! [IndexPath], with: UITableView.RowAnimation.none)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CSNodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CSNodeTableViewCell
        let nodeModel: CSNodeModel = dataSource[indexPath.row] as! CSNodeModel
        cell.nodeModel = nodeModel
        cell.delegate = self
        cell.cellSize = CGSize.init(width: kScreenWidth, height: 44)
        cell.cellIndexPath = indexPath as NSIndexPath
        cell.refreshCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MainViewController: CSNodeTableViewCellDelegate {
    func nodeTableView(cell: CSNodeTableViewCell, isExpand: Bool, at indexPath: NSIndexPath) {
        if isExpand {
            expandChildNodes(level: (cell.nodeModel?.level)!, at: indexPath)
        }else {
            hiddenChildNodes(level: (cell.nodeModel?.level)!, at: indexPath)
        }
    }
    func nodeTableView(cell: CSNodeTableViewCell, isSelected: Bool, at indexPath: NSIndexPath) {
        selectedChildNodes(level: (cell.nodeModel?.level)!, isSelected: isSelected, at: indexPath)
    }
}
