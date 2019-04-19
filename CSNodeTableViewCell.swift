//
//  CSNodeTableViewCell.swift
//  MostLevelTableViewCell
//
//  Created by changsheng yu on 2019/4/18.
//  Copyright © 2019 changsheng yu. All rights reserved.
//

import UIKit

protocol CSNodeTableViewCellDelegate: NSObjectProtocol {
    //选中的代理
    func nodeTableView(cell: CSNodeTableViewCell, isSelected: Bool, at indexPath: NSIndexPath)
    //展开的代理
    func nodeTableView(cell: CSNodeTableViewCell, isExpand: Bool, at indexPath: NSIndexPath)
}

class CSNodeTableViewCell: UITableViewCell {
    var nodeModel: CSNodeModel?
    var cellIndexPath: NSIndexPath?
    var cellSize: CGSize?
    weak var delegate: CSNodeTableViewCellDelegate?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var selectedBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(selectedClick), for: .touchUpInside)
        return btn
    }()
    lazy var expandBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(expandBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func selectedClick(sender: UIButton) {
        if !(nodeModel?.isSelected)! {
            selectedBtn.setImage(UIImage.init(named: "selected"), for: .normal)
        }else {
            selectedBtn.setImage(UIImage.init(named: "disSelected"), for: .normal)
        }
        nodeModel?.isSelected = !(nodeModel?.isSelected)!
        delegate?.nodeTableView(cell: self, isSelected: (nodeModel?.isSelected)!, at: cellIndexPath!)
    }
    @objc func expandBtnClick(sender: UIButton) {
        if !(nodeModel?.isExpand)! {
            expandBtn.setImage(UIImage.init(named: "expand"), for: .normal)
        }else {
            expandBtn.setImage(UIImage.init(named: "noExpand"), for: .normal)
        }
        nodeModel?.isExpand = !(nodeModel?.isExpand)!
        delegate?.nodeTableView(cell: self, isExpand: (nodeModel?.isExpand)!, at: cellIndexPath!)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(selectedBtn)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(expandBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - 刷新cell
    func refreshCell() {
        if (nodeModel?.isSelected)! {
            selectedBtn.setImage(UIImage.init(named: "selected"), for: .normal)
        }else {
            selectedBtn.setImage(UIImage.init(named: "disSelected"), for: .normal)
        }
        if !(nodeModel?.isExpand)! {
            expandBtn.setImage(UIImage.init(named: "expand"), for: .normal)
        }else {
            expandBtn.setImage(UIImage.init(named: "noExpand"), for: .normal)
        }
        let selectedSize: CGSize = CGSize.init(width: 20, height: 20)
        let expandSize: CGSize = CGSize.init(width: 20, height: 20)
        let x: CGFloat = 8 + CGFloat(nodeModel!.level-1) * CGFloat(selectedSize.width)
        let y: CGFloat = ((cellSize?.height)!-selectedSize.height)/2.0
        selectedBtn.frame = CGRect.init(x: x, y: y, width: selectedSize.width, height: selectedSize.height)
        expandBtn.frame = CGRect.init(x: CGFloat((cellSize?.width)! - 8 - expandSize.width), y: ((cellSize?.height)! - expandSize.height)/2.0, width: selectedSize.width, height: selectedSize.height)
        nameLabel.frame = CGRect.init(x: selectedBtn.frame.origin.x + selectedSize.width + 8, y: 0, width: expandBtn.frame.origin.x - 8 - (selectedBtn.frame.origin.x + selectedSize.width + 8), height: (cellSize?.height)!)
        nameLabel.text = nodeModel?.nodeName
        if (nodeModel?.isLeaf)! {
            expandBtn.isHidden = true
        }else {
            expandBtn.isHidden = false
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
