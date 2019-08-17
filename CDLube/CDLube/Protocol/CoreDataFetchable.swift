//
//  CoreDataFetchable.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import CoreData

public protocol CoreDataFetchable: NSFetchRequestResult {
    associatedtype FetchRequest = NSFetchRequest<Self>
    associatedtype FetchedResultsController = NSFetchedResultsController<Self>
}
