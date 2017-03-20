//
//  ClassScheduleDayModel.swift
//  mala-ios
//
//  Created by 王新宇 on 1/26/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class ClassScheduleDayModel: BaseObjectModel {

    // MARK: - Property
    var start: String?
    var end: String?
    var available: Bool = false
    var reserved: Bool = false
    var last_occupied_end: NSNumber?
    
    var isSelected: Bool = false
    var weekID: Int = 0
    
    
    // MARK: - Instance Method
    override init() {
        super.init()
    }
    
    convenience init(id: Int, start: String, end: String, available: Bool, reserved: Bool, weekID: Int) {
        self.init()
        self.id = id
        self.start = start
        self.end = end
        self.available = available
        self.reserved = reserved
        self.weekID = weekID
    }
    
    override init(dict: [String: Any]) {
        super.init(dict: dict)
        setValuesForKeys(dict)
    }
    
    required
    init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("ClassScheduleDayModel - Set for UndefinedKey: \(key)")
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["id", "start", "end", "available", "weekID"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
