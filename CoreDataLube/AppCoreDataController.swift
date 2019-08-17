//
//  AppCoreDataController.swift
//  CoreDataLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import CoreData
import CDLube

class AppCoreDataController: CoreDataController {
    private func installResourceOnViewContextOnce() {
        let ctx: NSManagedObjectContext
        if defaults.bool(forKey: resourceKey) {
            ctx = backgroundContext
        } else {
            ctx = viewContext
            defaults.set(true, forKey: resourceKey)
            installResource(ctx)
        }
    }
    func installResource(_ ctx: NSManagedObjectContext) {
        // Optionally install your resource once, potentially load it from file?
    }
    override func storeLoadSuccess() {
        super.storeLoadSuccess()
        installResourceOnViewContextOnce()
    }
}
