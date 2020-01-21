//
//  ViewController.swift
//  CollapsibleTableViewHeader
//
//  Created by Nitkarsh Gupta on 21/01/20.
//  Copyright © 2020 Nitkarsh Gupta. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 50
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .none
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    lazy private var topScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.clipsToBounds = true
        scrollView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        scrollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.2)
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 0
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.addArrangedSubview(self.searchView)
        return verticalStackView
    }()
    
    lazy var searchView: UIView = {
        let yourView = UIView()
        yourView.backgroundColor = .orange
        yourView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 100)
        return yourView
    }()
    
    lazy var searchView2: UIView = {
        let yourView = UISearchBar()
        yourView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 100)
        return yourView
    }()
    
    var heightV: CGFloat {
        self.stackView.frame.height
    }
    
    var heightF: CGFloat {
        self.searchView.frame.height
    }
    
    var widthF: CGFloat {
        UIScreen.main.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: heightF)
        topScrollView.frame = CGRect(x: self.tableView.frame.minX, y: self.tableView.frame.minY, width: widthF, height: self.heightF)
        self.view.addSubview(topScrollView)

        self.view.bringSubviewToFront(self.topScrollView)
        self.view.sendSubviewToBack(self.tableView)
        tableView.contentInset = UIEdgeInsets(top: self.heightF, left: 0, bottom: 0, right: 0)
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.stackView.insertArrangedSubview(self.searchView2, at: 0)
            self.topScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.heightF + self.heightF)
            self.topScrollView.frame = CGRect(x: self.tableView.frame.minX, y: self.tableView.frame.minY, width: self.widthF, height: self.heightF + self.heightF)
            self.view.layoutIfNeeded()
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .purple
        } else {
            cell.backgroundColor = .brown
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let y = 100 - (scrollView.contentOffset.y + 100)
            let height = min(max(y, 50), 100)
            self.topScrollView.frame = CGRect(x: self.tableView.frame.minX, y: self.tableView.frame.minY, width: UIScreen.main.bounds.size.width, height: height)
        }
    }
}

