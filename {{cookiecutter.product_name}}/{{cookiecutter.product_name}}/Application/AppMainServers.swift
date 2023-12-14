//
//  AppMainServers.swift
//  Templates
//
//  Created by SanW on 2023/12/12.
//  Copyright © 2023 SanW. All rights reserved.
//

var done = false

class AppMainServers: NSObject, HCYAppDelegateService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.isIdleTimerDisabled = true
        let delayDuration: TimeInterval = 2.0
        let connectionTimer = Timer.scheduledTimer(timeInterval: delayDuration, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: false)
        RunLoop.current.add(connectionTimer, forMode: .default)
        repeat {
            // 设置1.0秒检测做一次do...while的循环
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
        } while !done

        window?.backgroundColor = UIColor.black
        let rootViewController = AppConfigUtil.configRootViewController().0
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }

    @objc func timerFired(_: Timer) {
        done = true
    }
}
