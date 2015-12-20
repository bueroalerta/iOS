//
//  Common.swift
//  mala-ios
//
//  Created by Elors on 15/12/17.
//  Copyright © 2015年 Mala Online. All rights reserved.
//

import UIKit

// MARK: - Appearance TintColor
let MalaAppearanceTintColor = UIColor.redColor()
let MalaAppearanceTextColor = UIColor.whiteColor()


// MARK: - Common String 
let MalaCommonString_Malalaoshi = "麻辣老师"
let MalaCommonString_Profile = "个人"


// MARK: - Common Proportion
let MalaProportion_HomeCellWidthWithScreenWidth: CGFloat = 0.47
let MalaProportion_HomeCellMarginWithScreenWidth: CGFloat = 0.02
let MalaProportion_HomeCellHeightWithWidth: CGFloat = 1.28


// MARK: - Device
let MalaScreenWidth = UIScreen.mainScreen().bounds.size.width
let MalaScreenHeight = UIScreen.mainScreen().bounds.size.height

// MARK: - Common TextAttribute
public func commonTextStyle() -> [String: AnyObject]? {
    let AttributeDictionary = NSMutableDictionary()
    AttributeDictionary[NSForegroundColorAttributeName] = UIColor.whiteColor()
    return AttributeDictionary.copy() as? [String : AnyObject]
}