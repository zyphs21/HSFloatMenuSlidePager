//
//  BasicPageScrollSubViewProtocol.swift
//  HSFloatMenuSlidePager
//
//  Created by Hanson on 2017/10/19.
//  Copyright © 2017年 HansonStudio. All rights reserved.
//

import UIKit

protocol BasicPageScrollViewDelegate: class {
    
    func scrollViewIsScrolling(_ scrollView: UIScrollView)
    
}

protocol BasicPageScrollSubViewProtocol: class {
    
    var tableView: UITableView { get set }
    
    weak var basicPageScrollViewDelegate: BasicPageScrollViewDelegate? { get set }
    
}
