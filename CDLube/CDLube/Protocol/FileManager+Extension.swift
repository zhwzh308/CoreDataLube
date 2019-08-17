//
//  FileManager+Extension.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import os.log
import Foundation

extension FileManager {
    @discardableResult func silentRmFile(atUrl url: URL) -> Bool {
        let path = url.path
        guard
            fileExists(atPath: path),
            isDeletableFile(atPath: path)
            else { return false }
        do {
            try removeItem(at: url)
            return true
        } catch {
            os_log(.error, log: CDLube.oslog, "silent remove file failed: %@", error.localizedDescription)
        }
        return false
    }
}
