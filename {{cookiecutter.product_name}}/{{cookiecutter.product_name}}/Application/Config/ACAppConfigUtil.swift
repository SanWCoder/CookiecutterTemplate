//
//  AppConfigUtil.swift
//  Templates
//
//  Created by SanW on 2023/5/12.
//  Copyright © 2023 SanW. All rights reserved.
//

import Foundation
import UIKit

public class AppConfigUtil: NSObject {
    public class func applicationConfig(launchOptions _: [UIApplication.LaunchOptionsKey: Any]?) {
        // 初始化支付
        configIAP()
        // 配置系统设置
        configAppInfo()
        // 初始化分析
        configAnalytics()
    }
    
    /// 配置rootViewController
    /// - Parameter rootViewController: <#rootViewController description#>
    /// - Returns: <#description#>
    public class func configRootViewController(rootViewController: UITabBarController? = nil) -> (UIViewController, Bool) {
        let tabVc: UITabBarController = UITabBarController.init()
        return (tabVc, true)
    }

    /// 初始化支付
    fileprivate class func configIAP() {
        
    }

    /// 配置系统设置
    /// - Returns: <#description#>
    fileprivate class func configAppInfo() {
        
    }

    /// 初始化分析
    /// - Returns: <#description#>
    fileprivate class func configAnalytics() {
    }

    /// 处理推送通知
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - type: <#type description#>
    ///   - params: <#params description#>
    /// - Returns: <#description#>
    public class func dealWithPushInfo(code _: Int?, type: Int?, params: [String: Any]?, isBack: Bool = false) {
        
    }

    public class func registeFcmToken(fcmToken: String?) {
        
    }
}
