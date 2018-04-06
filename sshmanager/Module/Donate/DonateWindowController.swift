//
//  DonateWindowController.swift
//  sshmanager
//
//  Created by gejw on 2018/4/6.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

class DonateWindowController: BaseWindowController {

    static let shared = DonateWindowController()

    convenience init() {
        self.init(windowNibName: .init(rawValue: "DonateWindowController"))
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
