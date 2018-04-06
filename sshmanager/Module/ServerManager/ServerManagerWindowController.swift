//
//  ServerManagerWindowController.swift
//  sshmanager
//
//  Created by gejw on 2018/4/5.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

class ServerManagerWindowController: BaseWindowController {

    static let shared = ServerManagerWindowController()

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var nameTextField: STextField!
    @IBOutlet weak var ipTextField: STextField!
    @IBOutlet weak var portTextField: STextField!
    @IBOutlet weak var usernameTextField: STextField!
    @IBOutlet weak var passwordTextField: STextField!

    private var server: ServerManager.Server? = nil {
        didSet {
            if let server = server {
                nameTextField.stringValue = server.name
                ipTextField.stringValue = server.ip
                portTextField.stringValue = server.port
                usernameTextField.stringValue = server.username
                passwordTextField.stringValue = server.password
            } else {
                nameTextField.stringValue = ""
                ipTextField.stringValue = ""
                portTextField.stringValue = ""
                usernameTextField.stringValue = ""
                passwordTextField.stringValue = ""
            }
        }
    }

    convenience init() {
        self.init(windowNibName: .init(rawValue: "ServerManagerWindowController"))
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        tableView.selectionHighlightStyle = .none
        tableView.register(NSNib(nibNamed: "ServerCell", bundle: nil),
                            forIdentifier: "ServerCell")
        tableView.allowsTypeSelect = false
        tableView.delegate = self
        tableView.dataSource = self

        ServerManager.shared.addUpdateBlock { [weak self] in
            // 更新服务器列表
            self?.tableView.reloadData()
        }
    }

    @IBAction func didClickImportButton(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        let i = openPanel.runModal()
        if(i == .OK){
            if let url = openPanel.url,
                let data = try? Data(contentsOf: url),
                let json = String(data: data, encoding: .utf8) {
                json.toServers().forEach { ServerManager.shared.servers.append($0) }
            }
        }
    }

    @IBAction func didClickExportButton(_ sender: NSButton) {
        guard let data = try? JSONEncoder().encode(ServerManager.shared.servers).jsonString()?.data(using: .utf8) else { return }
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "server_manager_\(Int(Date().timeIntervalSince1970))"
        savePanel.allowedFileTypes = ["json"]
        savePanel.allowsOtherFileTypes = true
        savePanel.isExtensionHidden = false
        savePanel.canCreateDirectories = true
        savePanel.begin { result in
            if result == .OK {
                if let url = savePanel.url {
                    try? data?.write(to: url)
                }
            }
        }
    }

    @IBAction func didClickNewButton(_ sender: NSButton) {
        server = nil
    }

    @IBAction func didClickSaveButton(_ sender: NSButton) {
        var name        = nameTextField.stringValue.trim()
        let ip          = ipTextField.stringValue.trim()
        var port        = portTextField.stringValue.trim()
        var username    = usernameTextField.stringValue.trim()
        let password    = passwordTextField.stringValue.trim()

        if ip == "" || (!ip.isIPv4() && !ip.isIPv6()) {
            ipTextField.shake()
            return
        }
        if password == "" {
            passwordTextField.shake()
            return
        }
        name = name == "" ? ip : name
        port = port == "" ? "22" : port
        username = username == "" ? "root" : username

        var server: ServerManager.Server?
        if let svr = self.server, ServerManager.shared.servers.index(where: { svr.time == $0.time }) != nil {
            server = svr
        } else {
            server = ServerManager.Server()
        }
        server?.name = name
        server?.ip = ip
        server?.port = port
        server?.username = username
        server?.password = password
        server?.save()
    }

}

extension ServerManagerWindowController: NSTableViewDelegate, NSTableViewDataSource {

    func tableViewSelectionDidChange(_ notification: Notification) {
        if let tableView = notification.object as? NSTableView {
            let row = tableView.selectedRow
            if row < 0 { return }
            self.server = ServerManager.shared.servers[row]
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return ServerManager.shared.servers.count
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 26
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: "ServerCell", owner: self) as? ServerCell

        let server = ServerManager.shared.servers[row]
        cell?.server = server

        return cell
    }

}
