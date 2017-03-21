//
//  CommentViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/7.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let CommentViewCellReuseId = "CommentViewCellReuseId"

class CommentViewController: BaseTableViewController {

    // MARK: - Property
    /// 优惠券模型数组
    var models: [StudentCourseModel] = [] {
        didSet {
            handleModels(models, tableView: tableView)
        }
    }
    /// 是否正在拉取数据
    var isFetching: Bool = false
    
    
    // MARK: - Components
    /// 下拉刷新视图
    private lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(CommentViewController.loadCourse), for: .valueChanged)
        return refresher
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        configure()
        loadCourse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendScreenTrack(SAMyCommentsViewName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func configure() {
        refreshControl = refresher
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 208
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        tableView.register(CommentViewCell.self, forCellReuseIdentifier: CommentViewCellReuseId)
    }
    
    private func setupUserInterface() {
        // Style
        defaultView.imageName = "comment_noData"
        defaultView.text = L10n.noComment
        defaultView.descText = L10n.commentLater
    }
    
    ///  获取学生课程信息
    @objc private func loadCourse() {
        
        // 屏蔽[正在刷新]时的操作
        guard isFetching == false else { return }
        isFetching = true
        
        refreshControl?.beginRefreshing()
        
        ///  获取学生课程信息
        MAProvider.getStudentSchedule(onlyPassed: true, failureHandler: { error in
            self.models = []
            self.refreshControl?.endRefreshing()
            self.isFetching = false
        }) { schedule in
            self.refreshControl?.endRefreshing()
            self.isFetching = false
            self.models = schedule
        }
    }

    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewCellReuseId, for: indexPath) as! CommentViewCell
        cell.selectionStyle = .none
        cell.model = self.models[indexPath.row]
        return cell
    }
}
