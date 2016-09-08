//
//  PaymentAmountCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class PaymentAmountCell: UITableViewCell {

    // MARK: - Property
    /// 金额
    private var amount: Int = 0 {
        didSet {
            amountLabel.text = amount.moneyCNY
            self.amountLabel.sizeToFit()
        }
    }
    
    // MARK: - Components
    /// 应付金额label
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.textColor = MalaColor_333333_0
        titleLabel.text = "应付金额"
        return titleLabel
    }()
    /// 金额标签
    private lazy var amountLabel: UILabel = {
        let amountLabel = UILabel()
        amountLabel.font = UIFont.systemFontOfSize(14)
        amountLabel.textColor = MalaColor_E36A5D_0
        amountLabel.text = "￥0.01"
        return amountLabel
    }()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        // Autolayout
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(16)
            make.left.equalTo(contentView.snp_left).offset(12)
            make.bottom.equalTo(contentView.snp_bottom).offset(-16)
        }
        amountLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(contentView.snp_right).offset(-12)
            make.height.equalTo(15)
        }
        
        amount = ServiceResponseOrder.amount == 0 ? MalaCourseChoosingObject.getAmount() ?? 0 : ServiceResponseOrder.amount
    }
}