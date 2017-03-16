//
//  MalaInstance.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

// MARK: - Common Instance
var MalaMainViewController: MainViewController?


// MARK: - Instance
/// 筛选条件
var MalaCondition: ConditionObject = ConditionObject()

/// 当前课程选择对象
var MalaCurrentCourse: CourseChoosingObject = CourseChoosingObject()
/// 其他课程服务数组
var MalaServiceObject: [OtherServiceModel] = MalaOtherService
/// 需支付金额
var amount: Int = 0
/// 订单对象
var MalaOrderObject: OrderForm = OrderForm()
/// 支付对象
///  see - https://www.pingxx.com/api#charges-支付
var MalaPaymentCharge: JSONDictionary = JSONDictionary()
/// 服务器返回订单对象
var ServiceResponseOrder: OrderForm = OrderForm()
/// 用户拥有奖学金数据模型数组
var MalaUserCoupons: [CouponModel] = []
/// 用户是否手动选择奖学金标识（若手动选择过奖学金，则不再动态计算奖学金最优使用方案）
var MalaUserDidSelectCoupon: Bool = false
/// 当前选择城市数据模型
var MalaCurrentCity: BaseObjectModel? = MalaUserDefaults.currentCity.value
/// 当前选择校区数据模型
var MalaCurrentSchool: SchoolModel? = MalaUserDefaults.currentSchool.value

/// 用户是否首次购买该学科课程标记
/// 进入[课程购买]页面时请求服务端并赋值，退出[课程购买]页面时置空
var MalaIsHasBeenEvaluatedThisSubject: Bool? = nil
/// 用户预览订单模型
var MalaOrderOverView: OrderForm = OrderForm()


/// 支付页面控制器，用于APPDelegate处理回调
weak var MalaPaymentController: PaymentViewController?
/// 支付前的预览页面控制器，用于订单超时后的返回处理
weak var MalaOverViewController: UIViewController?
/// 筛选条件选择下标记录
var MalaFilterIndexObject = filterSelectedIndexObject()


/// 用户学习报告数据对象
var MalaSubjectReport = SubjectReport()
/// 用户学习报告总练习数
var MalaReportTotalNum: CGFloat = 0
/// 用户学习报告正确练习数
var MalaReportRightNum: CGFloat = 0
