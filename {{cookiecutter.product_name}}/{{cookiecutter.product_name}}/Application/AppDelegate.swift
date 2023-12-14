//
//  AppDelegate.swift
//  Templates
//
//  Created by SanW on 2023/6/8.
//  Copyright © 2023 SanW. All rights reserved.
//

import UIKit

@main
class AppDelegate: AppDelegateManager {
    override var services: [AppDelegateManager] {
        return [
            AppMainServers(),
            AppMainServers(),
        ]
    }

    override init() {
        super.init()
        window = UIWindow(frame: UIScreen.main.bounds)
    }
}
