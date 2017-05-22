//
//  SMSResultModel.swift
//  mala-ios
//
//  Created by Elors on 1/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class SMSResultModel: NSObject {

    // MARK: - Property
    var sent: Bool = false
    var verified: Bool = false
    var first_login: Bool = false
    var token: String = ""
    var reason: String?
    
    
    // MARK: - Constructed
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("SMSResultModel - Set for UndefinedKey: \(key) -")
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["sent", "verified", "first_login", "token", "reason"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
