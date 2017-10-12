//
//  ViewController.swift
//  HSFloatMenuSlidePager
//
//  Created by Hanson on 2016/10/24.
//  Copyright © 2016年 HansonStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var rootScrollView: UIScrollView?
    var headerView: UIView?
    var segmentMenu: SegmentMenu?
    var contentSlidePageView: SlidePageView?
    var viewObservers = [UITableView]()
    var observing = true
    var headerViewHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.white
        
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        for view in viewObservers {
            view.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        }
        rootScrollView?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
    }
    
    func setUpView() {
        
        rootScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        rootScrollView?.delegate = self
        rootScrollView?.backgroundColor = UIColor.white
        rootScrollView?.showsHorizontalScrollIndicator = false
        rootScrollView?.showsVerticalScrollIndicator = false
        rootScrollView?.contentSize = CGSize(width: rootScrollView!.bounds.width, height: rootScrollView!.bounds.height + headerViewHeight)
        rootScrollView?.alwaysBounceVertical = true
        rootScrollView?.alwaysBounceHorizontal = false
        rootScrollView?.addObserver(self, forKeyPath: "contentOffset",
                                    options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                                    context: nil)
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerViewHeight))
        headerView?.backgroundColor = UIColor.cyan
        
        segmentMenu = SegmentMenu(frame: CGRect(x: 0, y: headerView!.frame.maxY, width: UIScreen.main.bounds.width, height: 40))
        segmentMenu?.menuTitleArray = ["动态", "新闻", "公告"]
        segmentMenu?.delegate = self
        
        var controllerArray : [UIViewController] = []
        
        let firstVC = FirstViewController()
        firstVC.title = "动态"
        firstVC.view.frame = CGRect(x: 0, y: segmentMenu!.frame.maxY, width: UIScreen.main.bounds.width, height: rootScrollView!.bounds.height - segmentMenu!.bounds.height)
        controllerArray.append(firstVC)
        viewObservers.append(firstVC.tableView)
        self.addChildViewController(firstVC)
        firstVC.tableView.addObserver(self, forKeyPath: "contentOffset",
                                       options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                                       context: nil)
        
        let secondVC = SecondViewController()
        secondVC.title = "新闻"
        secondVC.view.frame = CGRect(x: 0, y: segmentMenu!.frame.maxY, width: UIScreen.main.bounds.width, height: rootScrollView!.bounds.height - segmentMenu!.bounds.height)
        controllerArray.append(secondVC)
        viewObservers.append(secondVC.tableView!)
        self.addChildViewController(secondVC)
        secondVC.tableView?.addObserver(self, forKeyPath: "contentOffset",
                                      options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                                      context: nil)
        
        let thirdVC = ThirdViewController()
        thirdVC.title = "公告"
        thirdVC.view.frame = CGRect(x: 0, y: segmentMenu!.frame.maxY, width: UIScreen.main.bounds.width, height: rootScrollView!.bounds.height - segmentMenu!.bounds.height)
        controllerArray.append(thirdVC)
        viewObservers.append(thirdVC.tableView!)
        self.addChildViewController(thirdVC)
        thirdVC.tableView?.addObserver(self, forKeyPath: "contentOffset",
                                              options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                                              context: nil)
        
        contentSlidePageView = SlidePageView(frame: CGRect(x: 0, y: segmentMenu!.frame.maxY, width: UIScreen.main.bounds.width, height: rootScrollView!.bounds.height - segmentMenu!.bounds.height), controlls: controllerArray)
        contentSlidePageView?.slidePageDelegate = self
        
        self.view.addSubview(rootScrollView!)
        rootScrollView?.addSubview(headerView!)
        rootScrollView?.addSubview(segmentMenu!)
        rootScrollView?.addSubview(contentSlidePageView!)
    }
    
}


extension ViewController: UIScrollViewDelegate {
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rootScrollView {
            if scrollView.contentOffset.y >= headerViewHeight {
                rootScrollView?.isScrollEnabled = false
                self.contentSlidePageView?.isScrollEnabled = true
            }
        }else {
            // 当 subScrollView 滑动到顶时，停止响应，mainScrollView 开始响应。
            if scrollView.contentOffset.y <= 0 {
                self.contentSlidePageView?.isScrollEnabled = false
                rootScrollView?.isScrollEnabled = true
            }
        }
    }
    
    
    func handleScrollUp(_ scrollView: UIScrollView,
                        change: CGFloat,
                        oldPosition: CGPoint) {
        
        if scrollView.contentOffset.y < 0.0 {
            if rootScrollView!.contentOffset.y >= 0.0 {
                
                var yPos = rootScrollView!.contentOffset.y - change
                yPos = yPos < 0 ? 0 : yPos
                let updatedPos = CGPoint(x: rootScrollView!.contentOffset.x, y: yPos)
                setContentOffset(rootScrollView!, point: updatedPos)
                setContentOffset(scrollView, point: oldPosition)
            }
        }
    }
    
    func handleScrollDown(_ scrollView: UIScrollView,
                          change: CGFloat,
                          oldPosition: CGPoint) {
        
        let offset = headerViewHeight //(headerViewHeight! - headerViewOffsetHeight!)
        
        if rootScrollView!.contentOffset.y < offset {
            
            if scrollView.contentOffset.y >= 0.0 {
                
                var yPos = rootScrollView!.contentOffset.y - change
                yPos = yPos > offset ? offset : yPos
                let updatedPos = CGPoint(x: rootScrollView!.contentOffset.x, y: yPos)
                setContentOffset(rootScrollView!, point: updatedPos)
                setContentOffset(scrollView, point: oldPosition)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
//        if !observing { return }
//
//        let scrollView = object as? UIScrollView
//        if scrollView == nil { return }
//        if scrollView == self.rootScrollView {
//            if (scrollView?.contentOffset.y)! > headerViewHeight {
//                let offSetPoint = CGPoint(x: rootScrollView!.contentOffset.x, y: headerViewHeight)
//                setContentOffset(scrollView!, point: offSetPoint)
//            }
//            return
//        }
//        if scrollView == self.contentSlidePageView {
//
//        }
//
//        let changeValues = change! as [NSKeyValueChangeKey: AnyObject]
//
//        if let new = changeValues[NSKeyValueChangeKey.newKey]?.cgPointValue,
//            let old = changeValues[NSKeyValueChangeKey.oldKey]?.cgPointValue {
//
//            let diff = old.y - new.y
//
//            if diff > 0.0 {
//
//                handleScrollUp(scrollView!,
//                               change: diff,
//                               oldPosition: old)
//            } else {
//
//                handleScrollDown(scrollView!,
//                                 change: diff,
//                                 oldPosition: old)
//            }
//        }
    }

    func setContentOffset(_ scrollView: UIScrollView, point: CGPoint) {
        observing = false
        scrollView.contentOffset = point
        observing = true
    }
}


extension ViewController: SegmentMenuDelegate {
    func menuButtonDidClick(index: Int) {
        contentSlidePageView?.moveToView(index: index)
    }
}

extension ViewController: SlidePageViewDelegate {
    func viewDidSlide(index: Int) {
        segmentMenu?.setSelectButton(index: index)
    }
}

