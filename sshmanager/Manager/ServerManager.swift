//
//  ServerManager.swift
//  sshmanager
//
//  Created by gejw on 2018/4/5.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

private let serversKey = "sshmanager.servers"

extension String {

    func toServers() -> [ServerManager.Server] {
        var list = [ServerManager.Server]()
        if let data = self.data(using: .utf8) {
            let result = try? JSONDecoder().decode([ServerManager.Server].self, from: data)
            list = result ?? []
        }
        return list
    }

}

private extension Array where Element == ServerManager.Server {

    func save() {
        if let json = try? JSONEncoder().encode(self).jsonString() {
            let userDefault = UserDefaults.standard
            userDefault.set(json, forKey: serversKey)
            userDefault.synchronize()
        }
    }

}

extension ServerManager.Server {

    // 读取列表
    static func read() -> [ServerManager.Server] {
        var list = [ServerManager.Server]()

        let userDefault = UserDefaults.standard
        if let data = userDefault.string(forKey: serversKey)?.data(using: .utf8) {
            let result = try? JSONDecoder().decode([ServerManager.Server].self, from: data)
            list = result ?? []
        }

        return list
    }

    // 添加
    func save() {
        if let index = ServerManager.shared.servers.index(where: { $0.time == self.time }) {
            ServerManager.shared.servers.remove(at: index)
            ServerManager.shared.servers.insert(self, at: index)
        } else {
            ServerManager.shared.servers.append(self)
        }
    }

    // 删除
    func delete() {
        if let index = ServerManager.shared.servers.index(where: { $0.time == time }) {
            ServerManager.shared.servers.remove(at: index)
        }
    }

    func run() {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "ssh", ofType: "sh")!)
        let execPath = URL(fileURLWithPath: path.path)

        if !FileManager.default.fileExists(atPath: execPath.path) {
            try? FileManager.default.moveItem(at: path, to: execPath)
        }

        let cmd = "expect \(execPath.path) \(username) \(ip) \(port) \(password)"

        let script = """
        tell application "Terminal"
        activate
        do script "\(cmd)"
        end tell
        """
        NSAppleScript(source: script)?.executeAndReturnError(nil)
    }

}

class ServerManager: NSObject {

    struct Server: Codable {
        // 名字
        var name = ""
        // ip地址
        var ip = ""
        // 端口
        var port = "22"
        // 用户名
        var username = "root"
        // 登录密码
        var password = ""
        // 添加时间
        var time: TimeInterval = Date().timeIntervalSince1970

    }

    typealias UpdateBlock = () -> Void

    static let shared = ServerManager()

    private var updateBlocks = [UpdateBlock]()

    var servers = [Server]() {
        didSet {
            servers.save()
            // 通知更新
            updateBlocks.forEach { $0() }
        }
    }

    private override init() {
        super.init()
        servers = Server.read()
    }

    private func read() -> [Server] {
        let userDefault = UserDefaults.standard
        return userDefault.string(forKey: "servers")?.toServers() ?? []
    }

    func addUpdateBlock(_ block: @escaping UpdateBlock) {
        updateBlocks.append(block)
    }

}
