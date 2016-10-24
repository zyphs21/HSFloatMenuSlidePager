//
//  SlidePageView.swift
//  HSFloatMenuSlidePager
//
//  Created by Hanson on 2016/10/24.
//  Copyright © 2016年 HansonStudio. All rights reserved.
//

import UIKit

@objc protocol SlidePageViewDelegate {
    func viewDidSlide(index: Int)
}

class SlidePageView: UIScrollView {

    var contentView: UIView?
    var contentViews = [UIView]()
    var viewControllerQueue: [Int: UIViewController] = [:]
    var viewControllerArray: [UIViewController] = []
    weak var slidePageDelegate: SlidePageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, controlls: [UIViewController]) {
        self.init(frame: frame)
        
        self.viewControllerArray = controlls
        setUpView()
    }
    
    func setUpView() {
        self.contentSize = CGSize(width: CGFloat(viewControllerArray.count) * UIScreen.main.bounds.width, height: self.bounds.height)
        addViewControllerListWithIndex(index: 0)
    }
    
    func addViewControllerListWithIndex(index : Int) {
        if ((viewControllerQueue[index]) == nil) {
            let viewController = viewControllerArray[index]
            self.addSubview(viewController.view)
            viewController.view.frame = CGRect(x: CGFloat(index) * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: self.bounds.height)
            viewControllerQueue[index] = viewController
        }
    }
    
    func moveToView(index: Int) {
        if ((viewControllerQueue[index]) == nil) {
            addViewControllerListWithIndex(index : index)
        }
        self.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0), animated: true)
    }
}

extension SlidePageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.addViewControllerListWithIndex(index: (Int)(scrollView.contentOffset.x/UIScreen.main.bounds.width))
        slidePageDelegate?.viewDidSlide(index: (Int)(scrollView.contentOffset.x/UIScreen.main.bounds.width))
    }
}
