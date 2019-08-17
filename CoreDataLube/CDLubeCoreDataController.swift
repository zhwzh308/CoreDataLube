//
//  CDLubeCoreDataController.swift
//  CoreDataLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import CDLube
import CoreData
import UIKit

private let localizedCaseInsensitiveCompare = #selector(NSString.localizedCaseInsensitiveCompare)

extension TextEntity: CoreDataFetchable, DatedManagedObject {
    static var idSorted: NSSortDescriptor {
        return backendIdSortDescriptor(true)
    }
    static var idSortedFetchRequest: FetchRequest {
        let r: FetchRequest = fetchRequest(),
        sDescriptor = idSorted
        r.sortDescriptors = [sDescriptor]
        return r
    }
    static var orderedFetchRequest: FetchRequest {
        let r: FetchRequest = fetchRequest(),
        sDescriptor = NSSortDescriptor(key: #keyPath(name), ascending: true, selector: localizedCaseInsensitiveCompare)
        r.sortDescriptors = [sDescriptor]
        return r
    }
    private static func backendIdSortDescriptor(_ ascending: Bool) -> NSSortDescriptor {
        let sd = NSSortDescriptor(keyPath: \TextEntity.id, ascending: ascending)
        return sd
    }
}

extension ResultsDataControllerProtocol where Entity == TextEntity {
    var resultsController: Entity.FetchedResultsController {
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: viewContext,
                                          sectionNameKeyPath: nil, cacheName: nil)
    }
}

final class CDLubeCoreDataController: AppCoreDataController {
    static let shared = CDLubeCoreDataController()
    public override class var containerName: String {
        return "CoreDataLube"
    }
    private override init() {
        super.init()
    }
}
