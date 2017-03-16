//
//  LoginViewController.swift
//  mala-ios
//
//  Created by Erdi on 12/31/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Property
    /// 弹栈闭包
    var popAction: (()->())?
    /// 关闭闭包
    var closeAction: (()->())?
    
    // MARK: - Components
    /// 主要布局容器
    private lazy var contentView: UIView = {
        let contentView = UIView(UIColor.white)
        return contentView
    }()
    /// 容器顶部装饰线
    private lazy var topSeparator: UIView = {
        let topSeparator = UIView(UIColor(named: .SeparatorLine))
        return topSeparator
    }()
    /// 容器中部装饰线
    private lazy var middleSeparator: UIView = {
        let middleSeparator = UIView(UIColor(named: .SeparatorLine))
        return middleSeparator
    }()
    /// 容器底部装饰线
    private lazy var bottomSeparator: UIView = {
        let bottomSeparator = UIView(UIColor(named: .SeparatorLine))
        return bottomSeparator
    }()
    /// 手机图标
    private lazy var phoneIcon: UIImageView = {
        let phoneIcon = UIImageView(imageName: "phone")
        return phoneIcon
    }()
    /// [获取验证码] 按钮
    private lazy var codeGetButton: UIButton = {
        let codeGetButton = UIButton()
        codeGetButton.layer.borderColor = UIColor(named: .LoginBlue).cgColor
        codeGetButton.layer.borderWidth = 1.0
        codeGetButton.layer.cornerRadius = 3.0
        codeGetButton.layer.masksToBounds = true
        codeGetButton.setTitle(L10n.getVerificationCode, for: UIControlState())
        codeGetButton.setTitleColor(UIColor.white, for: UIControlState())
        codeGetButton.setTitleColor(UIColor(named: .LoginBlue), for: .disabled)
        codeGetButton.setBackgroundImage(UIImage.withColor(UIColor(named: .LoginBlue)), for: UIControlState())
        codeGetButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .disabled)
        codeGetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        codeGetButton.addTarget(self, action: #selector(LoginViewController.codeGetButtonDidTap), for: .touchUpInside)
        return codeGetButton
    }()
    /// [手机号错误] 提示
    private lazy var phoneError: UIButton = {
        let phoneError = UIButton()
        phoneError.setImage(UIImage(asset: .error), for: UIControlState())
        phoneError.setTitleColor(UIColor(named: .OrderStatusRed), for: UIControlState())
        phoneError.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        phoneError.setTitle(L10n.invalidNumber, for: UIControlState())
        phoneError.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        phoneError.isHidden = true
        return phoneError
    }()
    /// 手机号码输入框
    private lazy var phoneTextField: UITextField = {
        let phoneTextField = UITextField()
        phoneTextField.keyboardType = .numberPad
        phoneTextField.placeholder = L10n.inputYourNumber
        phoneTextField.font = UIFont.systemFont(ofSize: 14)
        phoneTextField.textColor = UIColor(named: .ArticleSubTitle)
        phoneTextField.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: .editingChanged)
        phoneTextField.clearButtonMode = .never
        return phoneTextField
    }()
    /// 验证码图标
    private lazy var codeIcon: UIImageView = {
        let codeIcon = UIImageView(imageName: "verifyCode")
        return codeIcon
    }()
    /// [验证码错误] 提示
    private lazy var codeError: UIButton = {
        let codeError = UIButton()
        codeError.setImage(UIImage(asset: .error), for: UIControlState())
        codeError.setTitleColor(UIColor(named: .OrderStatusRed), for: UIControlState())
        codeError.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        codeError.setTitle(L10n.verificationCodeNotMatch, for: UIControlState())
        codeError.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        codeError.isHidden = true
        return codeError
    }()
    /// 验证码输入框
    private lazy var codeTextField: UITextField = {
        let codeTextField = UITextField()
        codeTextField.keyboardType = .numberPad
        codeTextField.placeholder = L10n.inputVerificationCode
        codeTextField.textColor = UIColor(named: .ArticleSubTitle)
        codeTextField.font = UIFont.systemFont(ofSize: 14)
        codeTextField.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: .editingChanged)
        return codeTextField
    }()
    /// [验证] 按钮
    private lazy var verifyButton: UIButton = {
        let verifyButton = UIButton()
        verifyButton.layer.cornerRadius = 5
        verifyButton.layer.masksToBounds = true
        verifyButton.setTitle(L10n.verify, for: UIControlState())
        verifyButton.setTitleColor(UIColor.white, for: UIControlState())
        verifyButton.setBackgroundImage(UIImage.withColor(UIColor(named: .LoginBlue)), for: .disabled)
        verifyButton.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeBlueTranslucent95)), for: UIControlState())
        verifyButton.addTarget(self, action: #selector(LoginViewController.verifyButtonDidTap), for: .touchUpInside)
        return verifyButton
    }()
    // 协议label
    private lazy var protocolLabel: UILabel = {
        let protocolLabel = UILabel()
        protocolLabel.font = UIFont.systemFont(ofSize: 12)
        protocolLabel.textColor = UIColor(named: .HeaderTitle)
        protocolLabel.text = L10n.protocolDesc
        return protocolLabel
    }()
    // 协议文字label
    private lazy var protocolString: UILabel = {
        let protocolString = UILabel()
        protocolString.font = UIFont.systemFont(ofSize: 12)
        protocolString.textColor = UIColor(named: .ThemeBlueTranslucent95)
        protocolString.text = L10n.malaUserProtocol
        protocolString.isUserInteractionEnabled = true
        protocolString.addTapEvent(target: self, action: #selector(LoginViewController.protocolDidTap))
        return protocolString
    }()
    
    private var callMeInSeconds = MalaConfig.callMeInSeconds()
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        self.title = L10n.verify
        self.view.backgroundColor = UIColor(named: .RegularBackground)
        let leftBarButtonItem = UIBarButtonItem(customView:UIButton(imageName: "close", target: self, action: #selector(LoginViewController.closeButtonDidClick)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        // SubView
        view.addSubview(contentView)
        contentView.addSubview(topSeparator)
        contentView.addSubview(middleSeparator)
        contentView.addSubview(bottomSeparator)
        contentView.addSubview(phoneIcon)
        contentView.addSubview(codeGetButton)
        contentView.addSubview(phoneError)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(codeIcon)
        contentView.addSubview(codeError)
        contentView.addSubview(codeTextField)
        view.addSubview(verifyButton)
        view.addSubview(protocolLabel)
        view.addSubview(protocolString)
        
        // Autolayout
        contentView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view).offset(12)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(93)
        }
        topSeparator.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(contentView)
            maker.right.equalTo(contentView)
        }
        middleSeparator.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(contentView)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(contentView)
            maker.right.equalTo(contentView)
        }
        bottomSeparator.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(contentView)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(contentView)
            maker.right.equalTo(contentView)
        }
        phoneIcon.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(15)
            maker.left.equalTo(contentView).offset(14)
            maker.width.equalTo(10)
            maker.height.equalTo(15)
        }
        codeGetButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(9)
            maker.right.equalTo(contentView).offset(-12)
            maker.width.equalTo(67)
            maker.height.equalTo(27)
        }
        phoneError.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(codeGetButton)
            maker.right.equalTo(codeGetButton.snp.left).offset(-4)
            maker.width.equalTo(70)
            maker.height.equalTo(15)
        }
        phoneTextField.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(phoneIcon.snp.right).offset(10)
            maker.right.equalTo(phoneError.snp.left).offset(-5)
            maker.centerY.equalTo(phoneIcon)
            maker.height.equalTo(25)
        }
        codeIcon.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(contentView).offset(-15)
            maker.left.equalTo(contentView).offset(14)
        }
        codeError.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(contentView).offset(-9)
            maker.right.equalTo(contentView).offset(-12)
            maker.width.equalTo(70)
            maker.height.equalTo(27)
        }
        codeTextField.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(codeIcon.snp.right).offset(7)
            maker.right.equalTo(codeError.snp.left).offset(-5)
            maker.centerY.equalTo(codeIcon)
            maker.height.equalTo(25)
        }
        verifyButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView.snp.bottom).offset(12)
            maker.left.equalTo(view).offset(12)
            maker.right.equalTo(view).offset(-12)
            maker.height.equalTo(37)
        }
        protocolLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(verifyButton.snp.bottom).offset(12)
            maker.left.equalTo(view).offset(12)
            maker.right.equalTo(protocolString.snp.left)
        }
        protocolString.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(protocolLabel)
            maker.left.equalTo(protocolLabel.snp.right)
            // 增加高度，扩大热区
            maker.height.equalTo(protocolLabel).offset(10)
        }
    }
    
    private func validateMobile(_ mobile: String) -> Bool {
        
        // 演示账号处理
        if mobile.subStringToIndex(3) == "000" && mobile.characters.count == 4 {
            return true
        }
        
        // 正式手机号
        let mobileRegex = "^1[3|4|5|7|8][0-9]\\d{8}$"
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: mobile)
    }
    
    ///  倒计时
    private func countDown() {
        self.callMeInSeconds = MalaConfig.callMeInSeconds()
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .default))
        
        timer.scheduleRepeating(deadline: .now(), interval: 1)
        timer.setEventHandler { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.callMeInSeconds <= 0 { // 倒计时完成
                timer.cancel()
                DispatchQueue.main.async{ () -> Void in
                    strongSelf.codeGetButton.setTitle(L10n.getVerificationCode, for: UIControlState())
                    strongSelf.codeGetButton.isEnabled = true
                }
            }else { // 继续倒计时
                DispatchQueue.main.async{ () -> Void in
                    strongSelf.codeGetButton.setTitle(String(format: " %02ds后获取 ", Int(strongSelf.callMeInSeconds)), for: .normal)
                    strongSelf.codeGetButton.isEnabled = false
                }
                strongSelf.callMeInSeconds -= 1
            }
        }
        timer.resume()
    }
    
    
    // MARK: - Event Response
    ///  用户协议点击事件
    @objc private func protocolDidTap() {
        let webViewController = MalaSingleWebViewController()
        webViewController.url = ""
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        // 若当前有错误信息出现，用户开始编辑时移除错误显示
        if !phoneError.isHidden {
            phoneError.isHidden = true
        }else if !codeError.isHidden {
            codeError.isHidden = true
        }
    }
    
    @objc private func codeGetButtonDidTap() {        
        // 验证手机号
        if !validateMobile(phoneTextField.text ?? "") {
            self.phoneError.isHidden = false
            self.phoneTextField.text = ""
            self.phoneTextField.becomeFirstResponder()
            return
        }
                
        countDown()
        guard let phone = self.phoneTextField.text else { return }
        
        // 发送SMS
        MAProvider.sendSMS(phone: phone, failureHandler: { [weak self] error in
            self?.ShowToast(L10n.networkNotReachable)
        }) { [weak self] sent in
            DispatchQueue.main.async {
                self?.ShowToast(sent ? L10n.verificationCodeSentSuccess : L10n.verificationCodeSentFailure)
                self?.codeTextField.becomeFirstResponder()
            }
        }
    }

    @objc private func verifyButtonDidTap() {
        // 验证信息
        if !validateMobile(phoneTextField.text ?? "") {
            self.phoneError.isHidden = false
            self.phoneTextField.text = ""
            self.phoneTextField.becomeFirstResponder()
            return
        }
        if (codeTextField.text ?? "") == "" {
            self.codeError.isHidden = false
            self.codeTextField.text = ""
            self.codeTextField.becomeFirstResponder()
            return
        }
        
        guard let phone = self.phoneTextField.text else { return }
        guard let code = self.codeTextField.text else { return }
        // 验证SMS
        MAProvider.verifySMS(phone: phone, code: code, failureHandler: { (error) in
            self.resetStatus()
        }) { (loginUser) in
            
            println("信息获取成功：\(loginUser)")
            
            guard let loginUser = loginUser else {
                self.resetStatus()
                self.ShowToast(L10n.verificationCodeNotMatch)
                return
            }
            
            saveTokenAndUserInfo(loginUser)
            MalaUserDefaults.isLogouted = false
             
            if loginUser.firstLogin == true {
                self.switchViewToSaveName()
            }else {
                self.close(animated: true)
            }
            MalaCurrentInitAction?()
        }
    }
    
    @objc private func closeButtonDidClick() {
        closeAction?()
        dismiss(animated: true, completion: nil)
    }
    
    // 状态恢复
    func resetStatus() {
        DispatchQueue.main.async {
            self.codeError.isHidden = false
            self.codeTextField.text = ""
        }
    }
    
    func switchViewToSaveName() {
        DispatchQueue.main.async {
            let view = SaveNameView()
            view.controller = self
            self.view = view
        }
    }
    
    func close(animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            getInfoWhenLoginSuccess()
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    deinit {
        popAction?()
        MalaMainViewController?.loadUnpaindOrder()
        println("LoginViewController - Deinit")
    }
}
