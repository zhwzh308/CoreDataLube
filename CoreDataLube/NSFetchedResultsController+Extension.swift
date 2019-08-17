//
//  NSFetchedResultsController+Extension.swift
//  CoreDataLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import os.log
import CoreData

// This is optional, but recommended

extension NSFetchedResultsController {
    @objc func doFetch() {
        do {
            try performFetch()
        } catch {
            os_log(.error, "%@", error.localizedDescription)
        }
    }
    @objc var numberOfSections: Int {
        guard let sections = sections else { return 0 }
        return sections.count
    }
    @objc func rows(forSection section: Int) -> Int {
        guard let sections = sections else { return 0 }
        return sections[section].numberOfObjects
    }
    /*
    @objc func titleForHeaderInSection(_ section: Int) -> String? {
        guard
            let sections = sections,
            sections.count > section
            else { return nil }
        return sections[section].name
    }
 */
}
