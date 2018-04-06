//
//  MainMenu.swift
//  sshmanager
//
//  Created by gejw on 2018/4/5.
//  Copyright © 2018年 robinge. All rights reserved.
//

import Cocoa

class MainMenu: NSMenu {

    @IBOutlet weak var serversMenu: NSMenu!

    var serverItems = [NSMenuItem]()

    override func awakeFromNib() {
        super.awakeFromNib()

        ServerManager.shared.addUpdateBlock { [weak self] in
            // 更新服务器列表
            self?.updateServerList()
        }

        updateServerList()
    }
    // 点击退出按钮
    @IBAction func didClickQuitButton(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    // 点击捐助按钮
    @IBAction func didClickDonateButton(_ sender: NSMenuItem) {
        showWindow(DonateWindowController.shared)
    }

    // 点击关于按钮
    @IBAction func didClickAboutButton(_ sender: NSMenuItem) {
        showWindow(AboutWindowController.shared)
    }

    // 点击app设置
    @IBAction func didClickAppSettingButton(_ sender: NSMenuItem) {
        showWindow(AppSettingWindowController.shared)
    }

    // 点击弹出管理页面
    @IBAction func didClickServersManagerButton(_ sender: NSMenuItem) {
        showWindow(ServerManagerWindowController.shared)
    }

    func showWindow(_ window: NSWindowController) {
        window.showWindow(nil)
        window.window?.center()
        NSApp.activate(ignoringOtherApps: true)
    }

    func updateServerList() {
        serverItems.forEach { serversMenu.removeItem($0) }
        serverItems = []

        var index = 1000
        ServerManager.shared.servers.forEach { server in
            let item = NSMenuItem()
            item.title = server.name
            item.tag = index
            item.target = self
            item.action = #selector(didClickServerItem(item:))
            serverItems.append(item)

            index += 1
        }
        serverItems.forEach { serversMenu.addItem($0) }
    }

    @objc func didClickServerItem(item: NSMenuItem) {
        let server = ServerManager.shared.servers[item.tag - 1000]
        server.run()
    }

}

extension MainMenu {

}
