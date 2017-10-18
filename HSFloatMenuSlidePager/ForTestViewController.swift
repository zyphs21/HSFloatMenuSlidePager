//
//  ForTestViewController.swift
//  HSFloatMenuSlidePager
//
//  Created by Hanson on 2017/10/12.
//  Copyright © 2017年 HansonStudio. All rights reserved.
//

import UIKit

class ForTestViewController: UIViewController {

    let headerViewHeight: CGFloat = 160
    let segmentMenuHeight: CGFloat = 44
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var childScrollView: UIScrollView?
    
    lazy var vcArray: [BasicPageScrollSubViewProtocol] = {
        var array: [BasicPageScrollSubViewProtocol] = []
        let firstVC = FirstViewController()
        firstVC.title = "动态"
        firstVC.basicPageScrollViewDelegate = self
        array.append(firstVC)
        let secondVC = SecondViewController()
        secondVC.title = "新闻"
        secondVC.basicPageScrollViewDelegate = self
        array.append(secondVC)
        let thirdVC = ThirdViewController()
        thirdVC.title = "公告"
        thirdVC.basicPageScrollViewDelegate = self
        array.append(thirdVC)
        
        return array
    }()
    
    lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    lazy var headerView: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerViewHeight))
        header.backgroundColor = UIColor.cyan
        return header
    }()
    
    lazy var segmentMenu: SegmentMenu = {
        let segment = SegmentMenu(frame: CGRect(x: 0, y: headerViewHeight, width: screenWidth, height: segmentMenuHeight))
        segment.menuTitleArray = ["动态", "新闻", "公告"]
        segment.delegate = self
        return segment
    }()
    
    lazy var contentScrollView: SlidePageView = {
        let contentScrollView = SlidePageView(frame: CGRect(x: 0, y: headerViewHeight + segmentMenuHeight, width: screenWidth, height: screenHeight - segmentMenuHeight), controlls: vcArray as! [UIViewController])
        contentScrollView.slidePageDelegate = self
        contentScrollView.delegate = self
        return contentScrollView
    }()
    
    
    // MARK: - Life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor.white
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(headerView)
        mainScrollView.addSubview(segmentMenu)
        mainScrollView.addSubview(contentScrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension ForTestViewController: SlidePageViewDelegate {
    func viewDidSlide(index: Int) {
        segmentMenu.setSelectButton(index: index)
    }
}

extension ForTestViewController: SegmentMenuDelegate {
    func menuButtonDidClick(index: Int) {
        contentScrollView.moveToView(index: index)
    }
}

extension ForTestViewController: BasicPageScrollViewDelegate {
    
    func scrollViewIsScrolling(_ scrollView: UIScrollView) {
        childScrollView = scrollView
        if mainScrollView.contentOffset.y < headerViewHeight {
            scrollView.contentOffset = CGPoint.zero
            scrollView.showsVerticalScrollIndicator = false
            for view in vcArray {
                view.tableView.contentOffset = CGPoint.zero
            }
        } else {
            mainScrollView.contentOffset.y = headerViewHeight
            scrollView.showsVerticalScrollIndicator = true
        }
    }
}

extension ForTestViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if mainScrollView.contentOffset.y > headerViewHeight {
            mainScrollView.contentOffset.y = headerViewHeight
        }
        
        if let childScrollViewOffsetY = childScrollView?.contentOffset.y, childScrollViewOffsetY > 0 {
            mainScrollView.contentOffset.y = headerViewHeight
        }
    }
}
