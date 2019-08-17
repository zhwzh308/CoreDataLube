//
//  DatedManagedObject.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import Foundation

public protocol DatedManagedObject: AnyObject {
    var createdAt: Date? { get set }
    var updatedAt: Date? { get set }
    func touchAtDate(_ date: Date)
}

public extension DatedManagedObject {
    func touchAtDate(_ date: Date) {
        if createdAt == nil {
            createdAt = date
        }
        updatedAt = date
    }
}
