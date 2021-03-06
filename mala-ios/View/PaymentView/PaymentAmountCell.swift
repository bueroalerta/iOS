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
            amountLabel.text = amount.amountCNY
            self.amountLabel.sizeToFit()
        }
    }
    
    // MARK: - Components
    /// 应付金额label
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor(named: .ArticleTitle)
        titleLabel.text = "应付金额"
        return titleLabel
    }()
    /// 金额标签
    private lazy var amountLabel: UILabel = {
        let amountLabel = UILabel()
        amountLabel.font = UIFont.systemFont(ofSize: 14)
        amountLabel.textColor = UIColor(named: .OrderStatusRed)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        // Autolayout
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(16)
            maker.left.equalTo(contentView).offset(12)
            maker.bottom.equalTo(contentView).offset(-16)
        }
        amountLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(contentView)
            maker.right.equalTo(contentView).offset(-12)
            maker.height.equalTo(15)
        }
        
        amount = ServiceResponseOrder.amount == 0 ? MalaCurrentCourse.getAmount() ?? 0 : ServiceResponseOrder.amount
    }
}
