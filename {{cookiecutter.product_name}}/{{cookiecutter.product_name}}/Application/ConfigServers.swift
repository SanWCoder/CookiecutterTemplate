//
//  ConfigServers.swift
//  Templates
//
//  Created by SanW on 2023/12/12.
//  Copyright © 2023 SanW. All rights reserved.
//

import AVFAudio
import Schedule
import UIKit

class ConfigServers: NSObject, AppDelegateService {
    var timeIntervalPlan: Task? // 定时刷新页面
    var lastBgDate: Int64 = 0 // 进入后台时间
    var isEnterBack = false
    var isAllowRotation = false // 是否支持屏幕旋转
    var notificationUserInfo: [String: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 启动配置
        AppConfigUtil.applicationConfig(launchOptions: launchOptions)
        return true
    }

    // 後台
    func applicationDidEnterBackground(_: UIApplication) {
        lastBgDate = Date().secondsTimeInterval
        // 热启动重新生成SubSesstionId
        isEnterBack = true
    }

    func applicationWillEnterForeground(_: UIApplication) {
        let currDate = Date().secondsTimeInterval
        if (currDate - lastBgDate) > 10 * 60 {}
    }

    func applicationDidBecomeActive(_: UIApplication) {
        if isEnterBack {
            isEnterBack = false
        }
    }

    /// 设置某个页面是否可以旋转
    /// eg:(UIApplication.shared.delegate as! AppDelegate).isAllowRotation = true
    /// - Parameters:
    ///   - application: <#application description#>
    ///   - window: <#window description#>
    /// - Returns: <#description#>
    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        if isAllowRotation {
            return .all
        }
        return .portrait
    }

}

