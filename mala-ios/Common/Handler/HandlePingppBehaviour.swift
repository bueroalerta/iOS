//
//  HandlePingppBehaviour.swift
//  mala-ios
//
//  Created by 王新宇 on 3/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class HandlePingppBehaviour: NSObject {

    /// 最大自动重试次数
    let maxAutoRetry = 3
    /// 最大手动重试次数
    let maxRetry = 1
    /// 当前重试次数
    var currentRetry = 0
    /// 当前视图控制器
    weak var currentViewController: UIViewController?
    
    ///  处理支付结果回调
    ///
    ///  - parameter result:                支付结果: success, fail, cancel, invalid
    ///  - parameter error:                 PingppError对象
    ///  - parameter currentViewController: 当前视图控制器
    func handleResult(_ result: String?, error: PingppError?, currentViewController: UIViewController?) {
        
        guard currentViewController != nil else {
            ThemeHUD.hideActivityIndicator()
            println("HandlePingppBehaviour - 控制器为空")
            return
        }
        
        self.currentViewController = currentViewController
        
        guard let result = result, error == nil else {
            println("PingppError: code=\(error!.code), msg=\(error!.getMsg())")
            return
        }
        
        switch result {
        case "success":
            // 支付成功后，向服务端验证支付结果
            validateOrderStatus()
            
        case "cancel":
            showCancelAlert()
            
        case "fail":
            showFailAlert()
            
        default:
            println("无法解析支付结果")
            break
        }
    }
    
    ///  获取服务端订单状态(支付结果)
    ///
    ///  - returns: 支付结果
    func validateOrderStatus() {

        currentRetry += 1
        DispatchQueue.main.async(execute: { () -> Void in
            ThemeHUD.showActivityIndicator()
        })
        
        // 获取订单信息
        getOrderInfo(ServiceResponseOrder.id, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("HandlePingppBehaviour - validateOrderStatus Error \(errorMessage)")
            }
        }, completion: { order -> Void in
            println("订单状态获取成功 \(order.status)")
            
            // 根据[订单状态]和[课程是否被抢占标记]来判断支付结果
            DispatchQueue.main.async { () -> Void in
                
                // 判断订单状态
                if order.status == MalaOrderStatus.paid.rawValue {
                    
                    if order.isTeacherPublished == false && order.isLiveCourse == false {
                        // 老师已下架
                        self.showTeacherDisabledAlert()
                    }else if order.isTimeslotAllocated == false {
                        // 课程被抢买
                        self.showHasBeenPreemptedAlert()
                    }else {
                        // 支付成功
                        self.showSuccessAlert()
                    }
                }else {
                    if self.currentRetry == self.maxAutoRetry {
                        // 支付失败
                        self.currentRetry = 0
                        self.showFailAlert()
                    }else {
                        // 重新获取订单状态
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.validateOrderStatus()
                        })
                    }
                }
            }
        })
    }
    
    ///  课程被抢买弹窗
    func showHasBeenPreemptedAlert() {
        ThemeHUD.hideActivityIndicator()
        guard let viewController = currentViewController else { return }
        
        let alert = JSSAlertView().show(viewController,
                                        title: L10n.courseSoldout,
                                        buttonText: L10n.later,
                                        iconImage: UIImage(asset: .alertCourseBeenSeized)
        )
        alert.addAction(popToCourseChoosingViewController)
    }
    
    ///  老师已下架
    func showTeacherDisabledAlert() {
        ThemeHUD.hideActivityIndicator()
        guard let viewController = currentViewController else { return }
        
        let alert = JSSAlertView().show(viewController,
                                        title: L10n.teacherOffShelves,
                                        buttonText: L10n.later,
                                        iconImage: UIImage(asset: .alertCourseBeenSeized)
        )
        alert.addAction(popToRootViewController)
    }
    
    ///  支付取消弹窗
    func showCancelAlert() {
        ThemeHUD.hideActivityIndicator()
        guard let viewController = currentViewController else { return }
        
        let _ = JSSAlertView().show(viewController,
                                    title: L10n.paymentHasBeenCanceled,
                                    buttonText: L10n.later,
                                    iconImage: UIImage(asset: .alertPaymentFail)
        )
    }
    
    ///  支付成功弹窗
    func showSuccessAlert() {
        ThemeHUD.hideActivityIndicator()
        guard let viewController = currentViewController else { return }
        
        let alert = JSSAlertView().show(viewController,
                                        title: L10n.paymentSuccess,
                                        buttonText: L10n.later,
                                        iconImage: UIImage(asset: .alertPaymentSuccess)
        )
        alert.addAction(switchToClassSchedule)
    }
    
    ///  支付失败弹窗
    func showFailAlert() {
        ThemeHUD.hideActivityIndicator()
        guard let viewController = currentViewController else { return }
        
        var actionSet = (L10n.paymentFailure, L10n.refresh, validateOrderStatus)
        
        // 若已达到最大手动重连限制次数，则返回首页。否则用户可以手动刷新。
        if self.currentRetry == self.maxRetry {
            actionSet = (L10n.paymentInfoFetching, L10n.later, popToRootViewController)
        }else {
            currentRetry += 1
        }
        
        let alert = JSSAlertView().show(viewController,
                                        title: actionSet.0,
                                        buttonText: actionSet.1,
                                        iconImage: UIImage(asset: .alertPaymentFail)
        )
        alert.addAction(actionSet.2)
    }
    
    ///  退回首页
    func popToRootViewController() {
        guard let viewController = currentViewController else { return }
        
        // 回调回App时若直接PopToRootViewController会出现TabBar莫名自动添加一个item的问题，暂时使用此方式解决问题。
        ThemeHUD.showActivityIndicator()
        delay(0.5) { () -> Void in
            _ = viewController.navigationController?.popToRootViewController(animated: true)
            ThemeHUD.hideActivityIndicator()
        }
    }
    
    /// 切换到课程表页面
    func switchToClassSchedule() {
        ThemeHUD.showActivityIndicator()
        
        delay(0.5) { () -> Void in
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = MainViewController()
                appDelegate.switchTabBarControllerWithIndex(1)
            }
            ThemeHUD.hideActivityIndicator()
        }
    }
    
    ///  退回到选课页面
    func popToCourseChoosingViewController() {
        guard let viewController = currentViewController else { return }
        _ = viewController.navigationController?.popViewController(animated: true)
    }
}
