//
//  HSScrollView.swift
//  HSFloatMenuSlidePager
//
//  Created by Hanson on 2017/9/18.
//  Copyright © 2017年 HansonStudio. All rights reserved.
//

import UIKit

protocol HSScrollViewDelegate: class {
    func scrollViewScrolling(_ scrollView: UIScrollView)
}

class HSScrollView: UIViewController, UIScrollViewDelegate {

    weak var delegate: HSScrollViewDelegate?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewScrolling(scrollView)
    }
}

