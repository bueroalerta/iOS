//
//  LearningReportKnowledgeCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/19.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import Charts

class LearningReportKnowledgeCell: MalaBaseReportCardCell {
    
    // MARK: - Property
    /// 知识点数据
    private var model: [SingleTopicData] = MalaConfig.knowledgeSampleData() {
        didSet {
            resetData()
        }
    }
    override var asSample: Bool {
        didSet {
            if asSample {
                model = MalaConfig.knowledgeSampleData()
            }else {
                hideDescription()
                model = MalaSubjectReport.knowledges_accuracy
            }
        }
    }
    
    
    // MARK: - Components
    /// 学习信息标签
    private lazy var infoLabel: UILabel = {
        let label = UILabel(
            text: "注：21/50，即 答对题/总题目数",
            fontSize: 10,
            textColor: UIColor(named: .ChartLabel)
        )
        label.backgroundColor = UIColor(named: .ReportLabelBack)
        label.textAlignment = .center
        label.layer.cornerRadius = 11
        label.layer.masksToBounds = true
        return label
    }()
    /// 饼形统计视图
    private lazy var barChartView: ThemeHorizontalBarChartView = {
        let barChartView = ThemeHorizontalBarChartView()
        return barChartView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupUserInterface()
        resetData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        titleLabel.text = "知识点分析"
        descDetailLabel.text = "学生各模块水平相差过大，应提前进行针对性练习，实数和相似等模块需提高，多边形板块可以适当减少练习量。"
    }
    
    private func setupUserInterface() {
        // Style
        
        
        // SubViews
        layoutView.addSubview(infoLabel)
        layoutView.addSubview(barChartView)
        
        
        // Autolayout
        infoLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(170)
            maker.height.equalTo(22)
            maker.centerX.equalTo(layoutView)
            maker.top.equalTo(layoutView.snp.bottom).multipliedBy(0.17)
        }
        barChartView.snp.makeConstraints { (maker) in
            maker.top.equalTo(infoLabel.snp.bottom).offset(10)
            maker.left.equalTo(descView)
            maker.right.equalTo(descView)
            maker.bottom.equalTo(descView.snp.top).offset(-10)
        }
    }
    
    // 设置样本数据
    private func setupSampleData() {
        
    }
    
    // 重置数据
    private func resetData() {
        
        let data = model.count == 0 ? MalaConfig.knowledgeDefaultData() : model
        
        var index = -1
        let vals = data.map { (data) -> ThemeHorizontalBarData in
            index += 1
            return ThemeHorizontalBarData(title: data.name, color: MalaConfig.chartsColor()[index], rightNum: data.right_item, totalNum: data.total_item)
        }
        barChartView.vals = vals
    }
    
    override func hideDescription() {
        descDetailLabel.text = "学生各知识点颜色填充的越完整正确率越高，方便查看学生各知识点的掌握情况，有针对性的进行练习。"
    }
}
