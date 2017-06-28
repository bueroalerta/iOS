//
//  CommentViewWindow.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/12.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

open class CommentViewWindow: UIViewController, UITextViewDelegate {
    
    // MARK: - Property
    var model: StudentCourseModel = StudentCourseModel() {
        didSet {
            // 课程信息
            teacherNameLabel.text = model.teacher?.name
            subjectLabel.text = model.subject
            textView.text = model.comment?.content
            floatRating.rating = Float((model.comment?.score) ?? 0)
            
            // 课程类型
            if let isLive = model.isLiveCourse, isLive == true {
                liveCourseAvatarView.setAvatar(lecturer: model.lecturer?.avatar, assistant: model.teacher?.avatar)
                liveCourseAvatarView.isHidden = false
                avatar.isHidden = true
            }else {
                avatar.setImage(withURL: model.teacher?.avatar)
                avatar.isHidden = false
                liveCourseAvatarView.isHidden = true
            }   
        }
    }
    /// 是否仅为展示标记
    var isJustShow: Bool = true {
        didSet {
            // 若仅为展示用图，调整UI及交互样式
            switchingModeWithJustShow(isJustShow: isJustShow)
        }
    }
    /// 评价编辑模式标记
    var isEditingMode: Bool = false {
        didSet {
            // 切换为 [评价编辑模式] 或 [普通评价模式]
            if isEditingMode && (isEditingMode != oldValue) {
                changeToEditingMode()
            }else {
                changeToNormalMode(animated: true)
            }
        }
    }
    private var TextViewMaximumLength: Int = 200
    /// 自身强引用
    var strongSelf: CommentViewWindow?
    /// 遮罩层透明度
    let tBakcgroundTansperancy: CGFloat = 0.7
    /// 布局容器（窗口）
    var window: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    /// 内容视图
    var contentView: UIView?
    /// 单击背景close窗口
    var closeWhenTap: Bool = false
    /// 完成闭包
    var finishedAction: (()->())?
    
    
    // MARK: - Components
    /// 标题视图
    private lazy var titleView: UILabel = {
        let label = UILabel(
            text: "评价",
            fontSize: 16,
            textColor: UIColor(named: .ThemeBlue),
            textAlignment: .center
        )
        return label
    }()
    /// 关闭按钮
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .close), for: UIControlState())
        button.addTarget(self, action: #selector(CommentViewWindow.closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    /// 顶部装饰线
    private lazy var titleLine: UIView = {
        let view = UIView(UIColor(named: .ThemeBlue))
        return view
    }()
    /// 老师信息及评分控件容器
    private lazy var teacherContainer: UIView = {
        let view = UIView()
        return view
    }()
    /// 头像布局视图
    private lazy var avatarView: UIView = {
        let view = UIView()
        return view
    }()
    /// 老师头像
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView(
            cornerRadius: 69/2,
            image: "avatar_placeholder",
            contentMode: .scaleAspectFill
        )
        return imageView
    }()
    /// 双师直播课程头像
    private lazy var liveCourseAvatarView: LiveCourseAvatarView = {
        let view = LiveCourseAvatarView()
        return view
    }()
    /// 老师姓名label
    private lazy var teacherNameLabel: UILabel = {
        let label = UILabel(
            text: "老师姓名",
            fontSize : 13,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 教授科目label
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "教授科目",
            fontSize : 13,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 评分面板
    private lazy var floatRating: FloatRatingView = {
        let floatRating = FloatRatingView()
        return floatRating
    }()
    /// 描述 文字背景
    private lazy var textBackground: UIImageView = {
        let imageView = UIImageView(imageName: "aboutText_Background")
        return imageView
    }()
    /// 输入文本框
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = UIColor(named: .InfoText)
        textView.text = L10n.inputComment
        return textView
    }()
    /// 提交按钮装饰线
    private lazy var buttonSeparatorLine: UIView = {
        let view = UIView(UIColor(named: .ThemeBlue))
        return view
    }()
    /// 提交按钮
    private lazy var commitButton: UIButton = {
        let button = UIButton()
        button.setTitle("提  交", for: UIControlState())
        button.setTitle("提交中", for: .disabled)
        button.setTitleColor(UIColor(named: .CommitButtonNormal), for: UIControlState())
        button.setTitleColor(UIColor(named: .DescGray), for: .disabled)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .WhiteTranslucent9)), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .HighlightGray)), for: .highlighted)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .HighlightGray)), for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(CommentViewWindow.commitButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Constructed
    init() {
        super.init(nibName: nil, bundle: nil)
        view.frame = UIScreen.main.bounds
        setupUserInterface()
        
        // 持有自己强引用，使自己在外界没有强引用时依然存在。
        strongSelf = self
    }
    
    convenience init(contentView: UIView) {
        self.init()
        view.alpha = 0
        
        // 显示Window
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        // 设置属性
        self.contentView = contentView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Override
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if closeWhenTap {
            // 若触摸点不位于Window视图，关闭弹窗
            if let point = touches.first?.location(in: window), !window.point(inside: point, with: nil) {
                closeAlert(0)
            }
        }
    }
    
    
    // MARK: - API
    open func show() {
        animateAlert()
    }
    
    open func close() {
        closeAlert(0)
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: tBakcgroundTansperancy)
        window.backgroundColor = UIColor.white
        
        // SubViews
        view.addSubview(window)
        window.addSubview(titleView)
        window.addSubview(closeButton)
        window.addSubview(titleLine)
        window.addSubview(avatarView)
        avatarView.addSubview(avatar)
        avatarView.addSubview(liveCourseAvatarView)
        window.addSubview(teacherNameLabel)
        window.addSubview(subjectLabel)
        window.addSubview(floatRating)
        window.addSubview(textBackground)
        window.addSubview(textView)
        window.addSubview(buttonSeparatorLine)
        window.addSubview(commitButton)
        
        // Autolayout
        changeToNormalMode(animated: false)
    }
    
    ///  设置UI为普通模式
    private func changeToNormalMode(animated: Bool) {
        
        if animated {
            removeAllConstraints()
        }
        
        // Autolayout
        window.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(view)
            maker.width.equalTo(MalaLayout_CommentPopupWindowWidth)
            maker.height.equalTo(MalaLayout_CommentPopupWindowHeight)
        }
        titleView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(window)
            maker.left.equalTo(window)
            maker.right.equalTo(window)
            maker.height.equalTo(44)
        }
        closeButton.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(titleView)
            maker.right.equalTo(window).offset(-12)
        }
        titleLine.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(titleView.snp.bottom)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(window)
            maker.right.equalTo(window)
        }
        avatarView.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(window)
            maker.top.equalTo(titleLine.snp.bottom).offset(10)
            maker.width.equalTo(72)
            maker.height.equalTo(72)
        }
        avatar.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(avatarView)
            maker.top.equalTo(avatarView)
            maker.width.equalTo(MalaLayout_CoursePopupWindowTitleViewHeight)
            maker.height.equalTo(MalaLayout_CoursePopupWindowTitleViewHeight)
        }
        liveCourseAvatarView.snp.makeConstraints { (maker) in
            maker.center.equalTo(avatarView)
            maker.width.equalTo(72)
            maker.height.equalTo(45)
        }
        teacherNameLabel.snp.makeConstraints { (maker) -> Void in
            maker.right.equalTo(avatarView.snp.centerX).offset(-5)
            maker.top.equalTo(avatarView.snp.bottom).offset(10)
            maker.height.equalTo(13)
        }
        subjectLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(avatarView.snp.centerX).offset(5)
            maker.top.equalTo(avatarView.snp.bottom).offset(10)
            maker.height.equalTo(13)
        }
        floatRating.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(subjectLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(avatarView)
            maker.height.equalTo(30)
            maker.width.equalTo(120)
        }
        textBackground.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(floatRating.snp.bottom).offset(8)
            maker.left.equalTo(window).offset(18)
            maker.right.equalTo(window).offset(-18)
            maker.bottom.equalTo(buttonSeparatorLine.snp.top).offset(-12)
        }
        textView.snp.makeConstraints { (maker) -> Void in
            maker.edges.equalTo(textBackground).inset(UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 5))
        }
        buttonSeparatorLine.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(commitButton.snp.top)
            maker.left.equalTo(window)
            maker.right.equalTo(window)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        commitButton.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(window)
            maker.left.equalTo(window)
            maker.right.equalTo(window)
            maker.height.equalTo(44)
        }
        
        // Animate
        if animated {
            self.window.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.35, animations: { () -> Void in
                self.avatarView.alpha = 1
                self.teacherNameLabel.alpha = 1
                self.subjectLabel.alpha = 1
                self.floatRating.alpha = 1
                self.window.layoutIfNeeded()
            }) 
        }
    }
    
    ///  设置UI为编辑模式
    private func changeToEditingMode() {
        
        // Autolayout
        window.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view).offset(36)
            maker.centerX.equalTo(view)
            maker.width.equalTo(MalaLayout_CommentPopupWindowWidth)
            maker.height.equalTo(MalaLayout_CommentPopupWindowHeight)
        }
        textBackground.snp.remakeConstraints({ (maker) -> Void in
            maker.top.equalTo(titleLine.snp.bottom).offset(12)
            maker.left.equalTo(window).offset(18)
            maker.right.equalTo(window).offset(-18)
            maker.bottom.equalTo(buttonSeparatorLine.snp.top).offset(-12)
        })
        avatarView.snp.updateConstraints { (maker) -> Void in
            maker.centerX.equalTo(window)
            maker.top.equalTo(titleLine.snp.bottom)
            maker.width.equalTo(0)
            maker.height.equalTo(0)
        }
        teacherNameLabel.snp.updateConstraints { (maker) -> Void in
            maker.right.equalTo(avatarView.snp.centerX).offset(-5)
            maker.top.equalTo(avatarView.snp.bottom).offset(10)
            maker.height.equalTo(0)
        }
        subjectLabel.snp.updateConstraints { (maker) -> Void in
            maker.left.equalTo(avatarView.snp.centerX).offset(5)
            maker.top.equalTo(avatarView.snp.bottom).offset(10)
            maker.height.equalTo(0)
        }
        floatRating.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(subjectLabel.snp.bottom)
            maker.centerX.equalTo(avatarView)
            maker.height.equalTo(0)
            maker.width.equalTo(0)
        }
        
        // Animate
        self.window.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.avatarView.alpha = 0
            self.teacherNameLabel.alpha = 0
            self.subjectLabel.alpha = 0
            self.floatRating.alpha = 0
            self.window.layoutIfNeeded()
        }) 
    }
    
    ///  删除所有约束
    private func removeAllConstraints() {
        window.snp.removeConstraints()
        titleView.snp.removeConstraints()
        closeButton.snp.removeConstraints()
        titleLine.snp.removeConstraints()
        avatarView.snp.removeConstraints()
        teacherNameLabel.snp.removeConstraints()
        subjectLabel.snp.removeConstraints()
        floatRating.snp.removeConstraints()
        textView.snp.removeConstraints()
        buttonSeparatorLine.snp.removeConstraints()
        commitButton.snp.removeConstraints()
    }
    
    ///  根据 [是否仅为展示标记] 调整 UI、UX
    private func switchingModeWithJustShow(isJustShow justShow: Bool) {
        if justShow {
            // 提交按钮
            commitButton.removeTarget(self, action: #selector(CommentViewWindow.commitButtonDidTap(_:)), for: .touchUpInside)
            commitButton.addTarget(self, action: #selector(CommentViewWindow.closeButtonDidTap), for: .touchUpInside)
            commitButton.setTitle(L10n.later, for: UIControlState())
            
            // 评价文本框
            textView.isUserInteractionEnabled = false
            textView.textColor = UIColor(named: .HeaderTitle)
            
            // 评分组件
            floatRating.editable = false
        }else {
            adjustTextViewPlaceholder(isShow: true)
        }
    }
    
    private func animateAlert() {
        view.alpha = 0;
        let originTransform = self.window.transform
        self.window.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.0);
        
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.view.alpha = 1.0
            self.window.transform = originTransform
        }) 
    }
    
    private func animateDismiss() {
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.view.alpha = 0
            self.window.transform = CGAffineTransform()
        }, completion: { (bool) -> Void in
            self.closeAlert(0)
        })
    }
    
    private func closeAlert(_ buttonIndex: Int) {
        self.view.removeFromSuperview()
        // 释放自身强引用
        self.strongSelf = nil
    }
    
    private func adjustTextViewPlaceholder(isShow: Bool) {
        if isShow {
            textView.textColor = UIColor(named: .InfoText)
            textView.text = L10n.inputComment
        }else {
            textView.textColor = UIColor(named: .HeaderTitle)
            if textView.text == L10n.inputComment {
                textView.text = ""
            }
        }
    }
    
    private func saveComment() {
        // 验证数据并创建评论模型
        guard model.id != 0 else {
            showToast("课程信息错误，请稍后重试")
            commitButton.isEnabled = true
            return
        }
        guard floatRating.rating > 0 else {
            showToast("请给课程打个分吧")
            commitButton.isEnabled = true
            return
        }
        guard textView.text != L10n.inputComment else {
            showToast("请给课程写几句评价吧")
            commitButton.isEnabled = true
            return
        }
        let comment = CommentModel(id: 0, timeslot: model.id, score: Int(floatRating.rating), content: textView.text)
        
        /// 创建评论
        MAProvider.createComment(comment: comment, failureHandler: { error in
            self.showToast(L10n.networkNotReachable)
            self.commitButton.isEnabled = true
        }) { result in
            DispatchQueue.main.async {
                if result {
                    // 设置评价数据，用于Cell状态更新后显示评论
                    self.model.comment = comment
                    
                    self.showToast("评价成功")
                    delay(1.0, work: { () -> Void in
                        self.finishedAction?()
                        self.animateDismiss()
                    })
                }else {
                    self.showToast("评价失败，请重试")
                    self.commitButton.isEnabled = true
                }
            }
        }
    }
    
    
    // MARK: - Delegate
    open func textViewDidBeginEditing(_ textView: UITextView) {
        // 用户开始输入时，展开输入区域
        changeToEditingMode()
        adjustTextViewPlaceholder(isShow: false)
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        // 保证用户联想词汇同样会被捕捉
        if textView.text.characters.count > TextViewMaximumLength {
            textView.text = textView.text.substring(to: textView.text.index(textView.text.startIndex, offsetBy: TextViewMaximumLength-1))
        }
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        // 用户停止输入时，恢复初始布局
        changeToNormalMode(animated: true)
        
        // 结束编辑时若没有输入，则显示占位文字
        if textView.text == "" {
            adjustTextViewPlaceholder(isShow: true)
        }
    }
    
    
    // MARK: - Event Response
    @objc private func pressed(_ sender: UIButton!) {
        self.closeAlert(sender.tag)
    }
    
    @objc private func closeButtonDidTap() {
        close()
    }
    
    @objc private func commitButtonDidTap(_ sender: UIButton) {
        commitButton.isEnabled = false
        saveComment()
    }
}
