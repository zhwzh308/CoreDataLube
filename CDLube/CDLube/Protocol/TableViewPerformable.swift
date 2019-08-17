//
//  TableViewPerformable.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import UIKit

public protocol TableViewPerformable: Performable {
    func perform(_ t: UITableView)
}
