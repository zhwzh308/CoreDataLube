//
//  NSFetchedResultsChangeType+Extension.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import CoreData

extension NSFetchedResultsChangeType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .insert:
            return "insert"
        case .delete:
            return "delete"
        case .move:
            return "move"
        case .update:
            return "update"
        @unknown default:
            return "unknown"
        }
    }
}
