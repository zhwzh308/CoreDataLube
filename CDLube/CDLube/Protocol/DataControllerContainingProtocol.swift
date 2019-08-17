//
//  DataControllerContainingProtocol.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import CoreData

public protocol DataControllerContainingProtocol: class {
    associatedtype T: CoreDataController
    var dataController: T { get }
    var viewContext: NSManagedObjectContext { get }
}

public extension DataControllerContainingProtocol {
    var viewContext: NSManagedObjectContext { return dataController.viewContext }
}
