//
//  NSTableView.swift
//  sshmanager
//
//  Created by gejw on 2018/4/6.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

extension NSImage {

    public convenience init(named: String) {
        self.init(named: .init(named))!
    }

}

extension NSNib {

    public convenience init?(nibNamed: String, bundle: Bundle?) {
        self.init(nibNamed: .init(nibNamed), bundle: bundle)
    }

}

extension NSTableView {

    public func register(_ nib: NSNib?, forIdentifier identifier: String) {
        register(nib, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier))
    }

    func makeView(withIdentifier: String, owner: Any?) -> NSView? {
        return makeView(withIdentifier: NSUserInterfaceItemIdentifier(withIdentifier), owner: owner)
    }
}
