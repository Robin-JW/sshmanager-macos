//
//  AboutWindowController.swift
//  sshmanager
//
//  Created by gejw on 2018/4/6.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

class AboutWindowController: BaseWindowController {

    static let shared = AboutWindowController()
    @IBOutlet weak var nameLabel: NSTextField!

    convenience init() {
        self.init(windowNibName: .init(rawValue: "AboutWindowController"))
    }

    override func windowDidLoad() {
        super.windowDidLoad()


        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            nameLabel.stringValue = "SSH 一键登录管理 v\(version)"
        }
    }
    
    @IBAction func didClickWeiboButton(_ sender: NSButton) {
        openWeibo()
    }

    private func openWeibo() {
        NSWorkspace.shared.open(URL(string: "https://weibo.com/234399610")!)
    }

}
