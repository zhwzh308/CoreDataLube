//
//  Performable.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

public protocol Performable {
    associatedtype T
    func perform(_ t: T)
}
