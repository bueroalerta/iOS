//
//  MemberPrivilegesViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/16.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let MemberPrivilegesLearningReportCellReuseID = "MemberPrivilegesLearningReportCellReuseID"
private let MemberPrivilegesMemberSerivceCellReuseID = "MemberPrivilegesMemberSerivceCellReuseID"

class MemberPrivilegesViewController: UITableViewController {

    // MARK: - Property
    /// 学科学习报告模型
    var report: SubjectReport = SubjectReport() {
        didSet {
            MalaSubjectReport = report
        }
    }
    /// 总练习数
    var totalNum: CGFloat = 0 {
        didSet {
            MalaReportTotalNum = totalNum
        }
    }
    /// 练习正确数
    var rightNum: CGFloat = 0 {
        didSet {
            MalaReportRightNum = rightNum
        }
    }
    /// 学习报告状态
    var reportStatus: MalaLearningReportStatus = .LoggingIn {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    /// 是否已Push新控制器标示（屏蔽pop到本页面时的数据刷新动作）
    var isPushed: Bool = false

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUserInterface()
        setupNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isPushed {
            loadStudyReportOverview()
        }
        isPushed = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isPushed {
            sendScreenTrack(SAStudyReportViewName)
        }
    }

    
    // MARK: - Private Method
    private func configure() {
        
        tableView.estimatedRowHeight = 230
        
        // register
        tableView.register(LearningReportCell.self, forCellReuseIdentifier: MemberPrivilegesLearningReportCellReuseID)
        tableView.register(MemberSerivceCell.self, forCellReuseIdentifier: MemberPrivilegesMemberSerivceCellReuseID)
    }
    
    private func setupUserInterface() {
        // Style
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.separatorStyle = .none
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_PushIntroduction,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            
            if let index = notification.object as? Int {
                // 跳转到简介页面
                let viewController = ThemeIntroductionView()
                viewController.hidesBottomBarWhenPushed = true
                viewController.index = index
                viewController.title = L10n.member
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: MalaNotification_ReloadLearningReport,
            object: nil,
            queue: nil) { [weak self] (notification) in
                self?.loadStudyReportOverview()
        }
        
        NotificationCenter.default.addObserver(
            forName: MalaNotification_ShowLearningReport,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            
            /// 执行学习报告相关操作
            if let index = notification.object as? Int {
                
                switch index {
                case -1:
                    
                    // 登录
                    self?.login()
                    break
                    
                case 0:
                    
                    // 显示学习报告样本
                    self?.showReportDemo()
                    break
                    
                case 1:
                    
                    // 显示真实学习报告
                    self?.showMyReport()
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    // 获取学生学习报告总结
    private func loadStudyReportOverview() {
        
        reportStatus = .LoggingIn
        
        // 未登录状态
        if !MalaUserDefaults.isLogined {
            self.reportStatus = .UnLogged
            return
        }
        
        MAProvider.userStudyReport(failureHandler: { error in
            DispatchQueue.main.async {
                self.reportStatus = .Error
                self.showToast(L10n.memberServerError)
            }
        }) { [weak self] results in
            println("学习报告：\(results)")
            
            // 默认登录未报名状态
            var status: MalaLearningReportStatus = .UnSigned
            
            // 遍历学科报名情况
            for singleReport in results {
                
                // 已报名支持学习报告的科目
                if singleReport.subject_id == 1 && singleReport.supported && singleReport.purchased {
                    self?.totalNum = CGFloat(singleReport.total_nums)
                    self?.rightNum = CGFloat(singleReport.right_nums)
                    status = .MathSigned
                    break
                }
                
                // 报名非数学状态
                if singleReport.supported == true && singleReport.purchased == false {
                    status = .UnSignedMath
                }
            }
            
            // 若当前学习报告状态正确，获取学科学习报告数据
            if status == .MathSigned {
                self?.loadSubjectReport()
            }else {
                self?.reportStatus = status
            }
        }
    }
    
    // 获取学科学习报告
    private func loadSubjectReport() {
        MAProvider.userSubjectReport(id: 1, failureHandler: { error in
            DispatchQueue.main.async {
                self.reportStatus = .Error
                self.showToast(L10n.memberServerError)
            }
        }) { report in
            println("学科学习报告：\(report)")
            self.report = report
            self.reportStatus = .MathSigned
        }
    }
    
    
    // MARK: - Event Response
    /// 登录
    @objc private func login() {
                
        let loginViewController = LoginViewController()
        loginViewController.popAction = { [weak self] in
            self?.loadStudyReportOverview()
        }

        self.present(
            UINavigationController(rootViewController: loginViewController),
            animated: true,
            completion: { () -> Void in
                
        })
        isPushed = true
    }
    /// 显示学习报告样本
    @objc private func showReportDemo() {
        let viewController = LearningReportViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        isPushed = true
    }
    /// 显示我的学习报告
    @objc private func showMyReport() {
        let viewController = LearningReportViewController()
        viewController.sample = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        isPushed = true
    }
    
    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            /// 学习报告
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberPrivilegesLearningReportCellReuseID, for: indexPath) as! LearningReportCell
            
            println("\(self.rightNum)-\(self.totalNum)")
            
            cell.totalNum = self.totalNum
            cell.rightNum = self.rightNum
            cell.reportStatus = self.reportStatus
            
            return cell
            
        case 1:
            /// 会员专享
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberPrivilegesMemberSerivceCellReuseID, for: indexPath) as! MemberSerivceCell
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushIntroduction, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_ShowLearningReport, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_ReloadLearningReport, object: nil)
    }
}
