//
//  ResultsDataControllerProtocol.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import Foundation

public protocol ResultsDataControllerProtocol: DataControllerContainingProtocol {
    associatedtype Entity: CoreDataFetchable
    var fetchRequest: Entity.FetchRequest { get }
    var resultsController: Entity.FetchedResultsController { get }
}
