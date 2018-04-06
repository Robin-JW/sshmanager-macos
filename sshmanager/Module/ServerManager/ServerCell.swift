//
//  ServerCell.swift
//  sshmanager
//
//  Created by gejw on 2018/4/6.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

class ServerCell: NSTableCellView {

    var server: ServerManager.Server? {
        didSet {
            nameLabel.stringValue = server?.name ?? ""
        }
    }

    @IBOutlet weak var nameLabel: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "删除", action: #selector(didClickDeleteItem), keyEquivalent: ""))
        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }

    @objc private func didClickDeleteItem() {
        server?.delete()
    }

}
