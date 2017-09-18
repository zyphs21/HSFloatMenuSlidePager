//
//  TestViewController.swift
//  HSFloatMenuSlidePager
//
//  Created by Hanson on 2017/3/27.
//  Copyright © 2017年 HansonStudio. All rights reserved.
//

import UIKit

// MARK: PageTableViewDelegate
protocol PageViewDelegate: class {
    func scrollViewIsScrolling(scrollView: UIScrollView)
}


class PageViewController: UIViewController, UIScrollViewDelegate {
    // 代理
    weak var pageViewDelegate: PageViewDelegate?
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageViewDelegate?.scrollViewIsScrolling(scrollView: scrollView)
    }
}


class CustomGestureTableView: UITableView {
    /// 返回true  ---- 能同时识别多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer is UIPanGestureRecognizer) && (otherGestureRecognizer is UIPanGestureRecognizer)
    }
}

let segmentViewHeight: CGFloat = 44.0
let naviBarHeight: CGFloat  = 64.0
let headViewHeight: CGFloat  = 300.0

// MARK: - TestViewController

class TestViewController: UIViewController {

    var childScrollView: UIScrollView?
    
    lazy var navibarView: UIView = {
        let navibar = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: naviBarHeight))
        navibar.backgroundColor = UIColor.blue
        return navibar
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headViewHeight))
        headerView.backgroundColor = UIColor.cyan
        let button = UIButton(frame: CGRect(x: 20, y: 50, width: 60, height: 40))
        button.setTitle("test", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(buttonTouch), for: .touchUpInside)
        button.center = headerView.center
        headerView.addSubview(button)
        return headerView
    }()
    
    lazy var segmentMenu: SegmentMenu = { [unowned self] in
        let segment = SegmentMenu(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: segmentViewHeight))
        segment.menuTitleArray = ["动态", "新闻", "公告"]
        segment.delegate = self
        return segment
    }()
    
    lazy var contentView: ContentView! = { [unowned self] in
        let contentView = ContentView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - naviBarHeight - segmentViewHeight), childVcs: self.setChildVcs(), parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    lazy var tableView: CustomGestureTableView = {[unowned self] in
        let table = CustomGestureTableView(frame: CGRect(x: 0.0, y: naviBarHeight, width: self.view.bounds.size.width, height: self.view.bounds.size.height - naviBarHeight), style: .plain)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(navibarView)
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.rowHeight = contentView.bounds.size.height
        tableView.sectionHeaderHeight = CGFloat(segmentViewHeight)
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setChildVcs() -> [UIViewController] {
        
        let titles = ["动态", "新闻", "公告"]
        var childVcs: [UIViewController] = []
        
        for (index, title) in titles.enumerated() {
            let childVc: PageViewController
            
            if index % 2 == 0 {
                childVc = FirstViewController()
                childVc.pageViewDelegate = self
            }
            else {
                childVc = SecondViewController()
                childVc.pageViewDelegate = self
            }
            childVc.title = title
            childVcs.append(childVc)
        }
        
        return childVcs
    }
    
    func buttonTouch() {
        print("button touch")
    }
}

extension TestViewController: PageViewDelegate {
    func scrollViewIsScrolling(scrollView: UIScrollView) {
        /// 记录便于处理联动
        childScrollView = scrollView
        
        if tableView.contentOffset.y < headViewHeight {
            scrollView.contentOffset = CGPoint.zero
            scrollView.showsVerticalScrollIndicator = false
        } else {
            tableView.contentOffset.y = headViewHeight
            scrollView.showsVerticalScrollIndicator = true
        }
    }
}

// MARK:- UIScrollViewDelegate 这里的代理可以监控tableView的滚动, 在滚动的时候就可以做一些事情, 比如使navigationBar渐变, 或者像简书一样改变头像的属性
extension TestViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let childScrollViewOffsetY = childScrollView?.contentOffset.y, childScrollViewOffsetY > 0 {
            tableView.contentOffset.y = headViewHeight
        }
        
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        
        cell.contentView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        
        cell.contentView.addSubview(contentView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentMenu
    }
    
}

extension TestViewController: ContentViewDelegate {
    var segmentView: SegmentMenu {
        return segmentMenu
    }
    
    // 监控开始滚动contentView的时候, 这里将滚动条滚动至顶部(简书没有这个效果,但其他的有---这里拒绝广告)
    func contentViewDidBeginMove() {
        tableView.setContentOffset(CGPoint(x: 0.0, y: headViewHeight), animated: true)
    }
    
}

extension TestViewController: SegmentMenuDelegate {
    func menuButtonDidClick(index: Int) {
//        contentSlidePageView?.moveToView(index: index)
        self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: false)
    }
}
