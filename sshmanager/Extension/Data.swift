//
//  Data.swift
//  sshmanager
//
//  Created by gejw on 2018/4/6.
//  Copyright © 2018 robinge. All rights reserved.
//

import Foundation

extension Data {

    func jsonString() -> String? {
        return String(data: self, encoding: .utf8)
    }

}
