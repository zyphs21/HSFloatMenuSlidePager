//
//  SegmentMenu.swift
//  HSFloatingSegmetMenuView
//
//  Created by Hanson on 2016/10/24.
//  Copyright © 2016年 HansonStudio. All rights reserved.
//

import UIKit

@objc protocol SegmentMenuDelegate {
    func menuButtonDidClick(index: Int)
}

class SegmentMenu: UIView {

    weak var delegate: SegmentMenuDelegate?
    
    var bottomIndicator: UIView!
    var bottomLine: UIView!
    var buttonWidth: CGFloat = 0
    var menuButtonArray: [UIButton] = []
    
    var menuTitleArray: [String] = [] {
        willSet (newMenuNameArray) {
            self.addMenuButton(menuNameArray: newMenuNameArray)
        }
    }
    
    var selectedButton: UIButton? {
        willSet (newSelectButton) {
            if (newSelectButton == selectedButton) {
                return
            }
            selectedButton?.setTitleColor(UIColor.black, for: .normal)
            newSelectButton?.setTitleColor(UIColor.blue, for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.bottomIndicator.frame.origin.x = self.buttonWidth * CGFloat((newSelectButton?.tag)!)
            }
        }
    }
    
    var indicatorHeight: CGFloat = 2
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        bottomIndicator = UIView()
        bottomIndicator.backgroundColor = UIColor.blue
        bottomLine = UIView(frame: CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5))
        bottomLine.backgroundColor = UIColor.brown
        
        self.addSubview(bottomIndicator)
        self.addSubview(bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    
    fileprivate func addMenuButton(menuNameArray: [String]) {
        self.menuButtonArray.forEach() {$0.removeFromSuperview()}
        self.menuButtonArray.removeAll()
        
        buttonWidth = self.bounds.width / CGFloat(menuNameArray.count)
        var x: CGFloat = 0
        for index in 0 ..< menuNameArray.count {
            let button = UIButton()
            button.setTitle(menuNameArray[index], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(menuButtonDidClick(_:)), for: .touchUpInside)
            button.tag = index
            button.frame = CGRect(x: x, y: 0, width: buttonWidth, height: self.bounds.height)
            x += buttonWidth
            self.addSubview(button)
            menuButtonArray.append(button)
        }
        bottomIndicator.frame = CGRect(x: 0, y: self.bounds.height - indicatorHeight, width: buttonWidth, height: indicatorHeight)
    }
    
    func menuButtonDidClick(_ button: UIButton) {
        setSelectButton(index: button.tag)
        //delegate?.menuButtonDidClick(index: button.tag)
    }
    
    func setSelectButton(index: Int) {
        if (self.menuButtonArray.count > 0){
            self.selectedButton = self.menuButtonArray[index]
            delegate?.menuButtonDidClick(index: index)
        }
    }
}
