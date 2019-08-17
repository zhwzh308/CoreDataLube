//
//  TableViewController.swift
//  CoreDataLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import os.log
import CDLube
import CoreData
import UIKit

class TableViewController: UITableViewController, ResultsDataControllerProtocol {
    @IBOutlet weak var resultDelegate: StandardTableViewFetchedResultsController!
    typealias Entity = TextEntity
    var fetchRequest: TextEntity.FetchRequest {
        let r = TextEntity.idSortedFetchRequest
        r.predicate = NSPredicate(format: "%K != %@", #keyPath(TextEntity.markedForDeletion), NSNumber(booleanLiteral: true))
        return r
    }
    var dataController: CDLubeCoreDataController { return .shared }
    var viewContext: NSManagedObjectContext { return dataController.viewContext }
    private lazy var results = resultsController
    override func viewDidLoad() {
        super.viewDidLoad()
        results.delegate = resultDelegate
        results.doFetch()
        os_log(.info, "fetched %d section(s), section 0 has %d rows", results.numberOfSections, results.rows(forSection: 0))
        // Grab the button item from storyboard, add edit button for the table
        guard let item = navigationItem.rightBarButtonItem else { return }
        navigationItem.rightBarButtonItems = [item, editButtonItem]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return results.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.rows(forSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath),
        object = results.object(at: indexPath)

        // Configure the cell...
        cell.textLabel?.text = object.name
        cell.detailTextLabel?.text = object.subtitle

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = results.sections else { return nil }
        return sections[section].indexTitle
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return results.section(forSectionIndexTitle: title, at: index)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            results.object(at: indexPath).markedForDeletion = true
            dataController.saveContext()
        case .insert:
            createRecord()
        case .none:
            break
        @unknown default:
            #if DEBUG
            fatalError()
            #else
            break
            #endif
        }
    }
    @IBAction private func addData(_ sender: UINavigationItem) {
        createRecord()
    }
    @discardableResult
    private func createRecord() -> TextEntity {
        let date = Date()
        let iso8601 = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        let title = iso8601.string(from: date)
        dateFormatter.dateStyle = .medium
        let subtitle = dateFormatter.string(from: date)
        let object = TextEntity(context: viewContext)
        object.id = numericCast(results.rows(forSection: 0)) + 1
        object.name = title
        object.subtitle = subtitle
        object.touchAtDate(date)
        object.markedForDeletion = false
        dataController.saveContext()
        os_log(.info, "Saved, fetched %d section(s), section 0 has %d rows", results.numberOfSections, results.rows(forSection: 0))
        return object
    }
}
