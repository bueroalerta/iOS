//
//  PaymentChannelSectionHeaderView.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class PaymentChannelSectionHeaderView: UIView {
    
    // MARK: - Components
    /// Section标题
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.textColor = MalaColor_6C6C6C_0
        titleLabel.text = "选择支付方式"
        return titleLabel
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        self.backgroundColor = UIColor.clearColor()
        
        // SubViews
        self.addSubview(titleLabel)
        
        // Autolayout
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(12)
            make.top.equalTo(self.snp_top).offset(10)
            make.bottom.equalTo(self.snp_bottom).offset(-10)
            make.height.equalTo(13)
        }
    }
}