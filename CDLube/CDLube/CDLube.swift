//
//  CDLube.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import os.log
import Foundation

private let identifier = "cdlube"

class CDLube {
    static let
    bundleId = Bundle.main.bundleIdentifier ?? identifier,
    oslog: OSLog = {
        let log = OSLog(subsystem: bundleId, category: identifier)
        return log
    }()
}
