//
//  AppSettingWindowController.swift
//  sshmanager
//
//  Created by gejw on 2018/4/5.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

class AppSettingWindowController: BaseWindowController {

    static let shared = AppSettingWindowController()
    @IBOutlet weak var stateLabel: NSTextField!

    convenience init() {
        self.init(windowNibName: .init(rawValue: "AppSettingWindowController"))
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        stateLabel.stringValue = FileManager.default.fileExists(atPath: "/usr/bin/expect") ? "expect 已安装" : "expect 未安装"
    }
    
    @IBAction func didClickInstallExpect(_ sender: NSButton) {
        let script = """
        tell application "Terminal"
        activate
        do script "brew install expect"
        end tell
        """
        NSAppleScript(source: script)?.executeAndReturnError(nil)
    }
}
