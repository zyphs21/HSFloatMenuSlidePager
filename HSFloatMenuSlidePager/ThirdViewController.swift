//
//  ThirdViewController.swift
//  HSFloatingSegmetMenuView
//
//  Created by Hanson on 2016/10/24.
//  Copyright © 2016年 HansonStudio. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, BasicPageScrollSubViewProtocol {
    
    weak var basicPageScrollViewDelegate: BasicPageScrollViewDelegate?

    var tableView = UITableView()
    let cellIdentifier = "UITableViewCell"
    lazy var testArray: [String] = {
        var array: [String] = []
        for i in 1...5 {
            array.append("\(i)-3")
        }
        return array
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        basicPageScrollViewDelegate?.scrollViewIsScrolling(scrollView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = testArray[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
