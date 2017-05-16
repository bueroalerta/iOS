//
//  MemberNoteCell.swift
//  mala-ios
//
//  Created by 王新宇 on 11/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class MemberNoteCell: MalaBaseMemberCardCell {

    // MARK: - Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "Hi 临沂校区 王新宇同学：",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary)
        )
        return label
    }()
    private lazy var helpButton: UIButton = {
        let button = UIButton()
        button.setTitle("错题哪里来？", for: .normal)
        button.setTitleColor(UIColor(named: .indexBlue), for: .normal)
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(14)
        return button
    }()
    private lazy var separator: UIView = {
        let line = UIView(UIColor(named: .lineGray))
        line.alpha = 0.3
        return line
    }()
    private lazy var englishIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(asset: .subjectEnglish))
        return icon
    }()
    private lazy var englishLabel: UILabel = {
        let label = UILabel(
            text: "31题",
            font: FontFamily.PingFangSC.Regular.font(20),
            textColor: UIColor(named: .subjectGray)
        )
        return label
    }()
    private lazy var mathIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(asset: .subjectMath))
        return icon
    }()
    private lazy var mathLabel: UILabel = {
        let label = UILabel(
            text: "124题",
            font: FontFamily.PingFangSC.Regular.font(20),
            textColor: UIColor(named: .subjectGray)
        )
        return label
    }()
    
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
//        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func setupUserInterface() {
        content.insertSubview(titleLabel, at: 0)
        content.insertSubview(helpButton, at: 1)
        content.insertSubview(separator, at: 2)
        content.insertSubview(englishIcon, at: 3)
        content.insertSubview(englishLabel, at: 4)
        content.insertSubview(mathIcon, at: 5)
        content.insertSubview(mathLabel, at: 6)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(166)
            maker.height.equalTo(20)
            maker.top.equalTo(content).offset(20)
            maker.left.equalTo(content).offset(20)
        }
        helpButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(84)
            maker.height.equalTo(20)
            maker.top.equalTo(content).offset(20)
            maker.right.equalTo(content).offset(-14)
        }
        separator.snp.makeConstraints { (maker) in
            maker.width.equalTo(1)
            maker.height.equalTo(53)
            maker.top.equalTo(titleLabel.snp.bottom).offset(60)
            maker.centerX.equalTo(content)
        }
        englishIcon.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(separator)
            maker.right.equalTo(separator.snp.left).offset(-42)
        }
        englishLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(englishIcon.snp.bottom).offset(17)
            maker.height.equalTo(28)
            maker.centerX.equalTo(englishIcon)
            maker.bottom.equalTo(content).offset(-40)
        }
        mathIcon.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(separator)
            maker.left.equalTo(separator.snp.right).offset(42)
        }
        mathLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(mathIcon.snp.bottom).offset(17)
            maker.height.equalTo(28)
            maker.centerX.equalTo(mathIcon)
            maker.bottom.equalTo(content).offset(-40)
        }
    }
    
    private func setup() {
        setupDefaultStyle(image: .noteNormal,
                          disabledImage: .noteDisable,
                          title: "你课中答错的题目会出现在这里哦！",
                          disabledTitle: "错题本数据获取失败！",
                          buttonTitle: "查看错题本样本")
        actionButton.addTarget(self, action: #selector(MemberNoteCell.buttonDidTap), for: .touchUpInside)
    }
    
    @objc private func buttonDidTap() {
        delay(3) { 
            self.defaultContainer.removeFromSuperview()
            
//            delay(2, work: { 
//                self.setupDefaultStyle(image: .noteNormal,
//                                       disabledImage: .noteDisable,
//                                       title: "你课中答错的题目会出现在这里哦！",
//                                       disabledTitle: "错题本数据获取失败！",
//                                       buttonTitle: "查看错题本样本")
//            })
        }
        MemberPrivilegesViewController.shared.showMistakeDemo()
    }
}

