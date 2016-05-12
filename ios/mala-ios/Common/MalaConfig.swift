//
//  MalaConfig.swift
//  mala-ios
//
//  Created by 王新宇 on 2/24/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

public class MalaConfig {
    
    static let appGroupID: String = "group.malalaoshi.parent"
    
    ///  短信倒计时时间
    class func callMeInSeconds() -> Int {
        return 60
    }
    ///  支付方式
    class func paymentChannel() -> [String] {
        return ["wechat", "alipay"]
    }
    ///  支付方式数
    class func paymentChannelAmount() -> Int {
        return paymentChannel().count
    }
    ///  头像最大大小
    class func avatarMaxSize() -> CGSize {
        return CGSize(width: 414, height: 414)
    }
    ///  头像压缩质量
    class func avatarCompressionQuality() -> CGFloat {
        return 0.7
    }
    ///  头像大小
    class func editProfileAvatarSize() -> CGFloat {
        return 100
    }
    ///  app版本号
    class func aboutAPPVersion() -> String {
        let version = String(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]!)
        return String(format: "版本 V%@", version ?? "1.0")
    }
    ///  版权信息
    class func aboutCopyRightString() -> String {
        return "COPYRIGHT © 2014 - 2016\n北京麻辣在线网络科技有限公司版权所有"
    }
    ///  关于我们描述HTMLString
    class func aboutDescriptionHTMLString() -> String {
        return "        麻辣老师(MALALAOSHI.COM)成立于2015年6月，由众多资深教育人士和互联网顶尖人才组成，是专注于国内二三四线城市中小学K12课外辅导的O2O服务平台，以效果、费用、便捷为切入口，实现个性化教学和学生的个性发展，推动二三四线城市及偏远地区教育进步。\n\n        麻辣老师通过O2O的方式，以高效和精准的老师推荐，让中小学家长更加方便和经济地找到好老师，提升老师的收入，优化教、学、练、测、评五大环节, 提升教学与学习效率、创新服务模式，带给家长、老师及学生全新的学习体验。"
    }
    ///  奖学金使用规则String
    class func couponRulesDescriptionString() -> String {
        return "奖学金券是什么\n1.奖学金券是由麻辣老师发行，使用户在麻辣老师购买课程的过程中，作为抵扣现金的一种虚拟券。\n二.使用规则\n1.不同的奖学金券面值、有效期和使用限制不尽相同，使用前请认真核对。\n2.一个订单只能使用一张奖学金券。\n3.奖学金券作为一种优惠手段，无法获得对应的积分。\n4.一个订单中的奖学金券部分不能退款或折现，使用奖学金券购买的订单发生退款后不能返还奖学金券。\n5.如取消订单，订单中所使用的奖学金券可再次使用。\n6.奖学金券面值大于订单金额，差额不予退回；如奖学金券面值小于订单金额，需由用户支付差额；奖学金券不可兑现，且不开发票。\n三.特别提示\n1.用户应当出于合法、正当目的，以合理方式使用奖学金券。\n2.麻辣老师将不定期的通过版本更新的方式修改使用规则，请您及时升级为最新版本。\n3.如果用户对使用规则存在任何疑问或需要任何帮助，请及时与麻辣老师客服联系。联系电话：010-57733349\n4.最终解释权归北京麻辣在线网络科技有限公司所有。"
    }
    
    
    // MARK: - Default Data
    ///  老师详情缺省模型
    class func defaultTeacherDetail() -> TeacherDetailModel {
        return TeacherDetailModel(
            id: 0,
            name: "老师姓名",
            avatar: "",
            gender: "m",
            teaching_age: 0,
            level: "一级",
            subject: "学科",
            grades: [],
            tags: [],
            photo_set: [],
            achievement_set: [],
            highscore_set: [],
            prices: [],
            minPrice: 0,
            maxPrice: 0
        )
    }
    
    ///  [个人中心]静态结构数据
    class func profileData() -> [[ProfileElementModel]] {        
        return [
            [
                ProfileElementModel(
                    id: 0,
                    title: "学生姓名",
                    detail: MalaUserDefaults.studentName.value ?? "",
                    controller: InfoModifyViewController.self,
                    controllerTitle: "更改名字",
                    type: .StudentName
                ),
                ProfileElementModel(
                    id: 1,
                    title: "学校信息",
                    detail: MalaUserDefaults.schoolName.value ?? "",
                    controller: InfoModifyViewController.self,
                    controllerTitle: "所在学校",
                    type: .StudentSchoolName
                ),
                /*ProfileElementModel(
                    id: 2, 
                    title: "所在城市",
                    detail: "", 
                    controller: InfoModifyViewController.self,
                    controllerTitle: "所在城市",
                    type: nil
                ),*/
                ProfileElementModel(
                    id: 2,
                    title: "我的订单",
                    detail: "待支付订单",
                    controller: OrderFormViewController.self,
                    controllerTitle: "我的订单",
                    type: nil,
                    badgeNumber: 1
                ),
                ProfileElementModel(
                    id: 3,
                    title: "我的奖学金",
                    detail: "",
                    controller: CouponViewController.self,
                    controllerTitle: "我的奖学金",
                    type: nil
                )
            ],
            [
                ProfileElementModel(
                    id: 4,
                    title: "关于麻辣老师",
                    detail: "",
                    controller: AboutViewController.self,
                    controllerTitle: "关于麻辣老师",
                    type: nil
                )
            ]
        ]
    }
}