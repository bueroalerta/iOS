//
//  ProfileElementModel.swift
//  mala-ios
//
//  Created by 王新宇 on 3/11/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class ProfileElementModel: BaseObjectModel {
    
    // MARK: - Property
    /// 标题
    var title: String = ""
    /// 信息
    var detail: String = ""
    /// 跳转控制器
    var controller: AnyClass?
    /// 跳转控制器标题
    var controllerTitle: String?
    /// 信息类型
    var type: userInfoType?
    /// 新消息数
    var badgeNumber: Int? = 0
    /// 图标名称
    var iconName: String = ""
    /// 新消息图片名称
    var newMessageIconName: String = ""
    
    /// 是否冻结
    var disabled: Bool = false
    /// 冻结信息
    var disabledMessage: String? = nil
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    override init(dict: [String: Any]) {
        super.init(dict: dict)
        setValuesForKeys(dict)
    }
    
    convenience init(id: Int, title: String = "", detail: String = "", controller: AnyClass?, controllerTitle: String, type: userInfoType?, badgeNumber: Int? = 0, iconName: String = "", newMessageIconName: String = "", disabled: Bool = false, disabledMessage: String? = nil) {
        self.init()
        self.id = id
        self.title = title
        self.detail = detail
        self.controller = controller
        self.controllerTitle = controllerTitle
        self.type = type
        self.badgeNumber = badgeNumber
        self.iconName = iconName
        self.newMessageIconName = newMessageIconName
        self.disabled = disabled
        self.disabledMessage = disabledMessage
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("ProfileElementModel - Set for UndefinedKey: \(key)")
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["id", "title", "detail", "controller", "type"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
