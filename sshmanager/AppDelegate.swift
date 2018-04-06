//
//  AppDelegate.swift
//  sshmanager
//
//  Created by gejw on 2018/4/5.
//  Copyright © 2018年 robinge. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var mainMenu: MainMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let image = NSImage(named: NSImage.Name("status_icon"))
        image?.isTemplate = true // 支持主题
        statusItem.image = image
        statusItem.alternateImage = image
        statusItem.menu = mainMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

