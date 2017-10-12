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
    
    lazy var vcArray: [UIViewController] = {
        var array: [UIViewController] = []
        let firstVC = FirstViewController()
        firstVC.title = "动态"
        array.append(firstVC)
        let secondVC = SecondViewController()
        secondVC.title = "新闻"
        array.append(secondVC)
        let thirdVC = ThirdViewController()
        thirdVC.title = "公告"
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
        let contentScrollView = SlidePageView(frame: CGRect(x: 0, y: headerViewHeight + segmentMenuHeight, width: screenWidth, height: screenHeight - segmentMenuHeight), controlls: vcArray)
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

// MARK: - SlidePageViewDelegate

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

extension ForTestViewController: UIScrollViewDelegate {
    
}
