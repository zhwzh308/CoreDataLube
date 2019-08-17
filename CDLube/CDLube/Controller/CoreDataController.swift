//
//  AppCoreDataController.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import os.log
import CoreData
import Foundation

private func urlForContainer(_ name: String) -> URL? {
    let bundle = Bundle.main,
    containerExtension = "momd"
    return bundle.url(forResource: name, withExtension: containerExtension)
}

open class CoreDataController: NSObject {
    static private let defaults = UserDefaults.standard,
    defaultDirectory = NSPersistentContainer.defaultDirectoryURL(),
    fileManager = FileManager.default
    open class var containerName: String {
        return ""
    }
    public class var entityName: String {
        return containerName
    }
    @discardableResult
    public static func removeStore(_ containerName: String) -> Bool {
        let fm = fileManager, fn = containerFileName(containerName)
        let url = defaultDirectory.appendingPathComponent(fn)
        return fm.silentRmFile(atUrl: url)
    }
    private static func containerFileName(_ name: String) -> String {
        return [name, "sqlite"].joined(separator: ".")
    }
    private static func createAtURL(_ url: URL, forName name: String) -> NSPersistentContainer? {
        os_log(.debug, log: CDLube.oslog, "Create at %@", url.description)
        guard let model = NSManagedObjectModel(contentsOf: url) else { return nil }
        return NSPersistentContainer(name: name, managedObjectModel: model)
    }
    public let persistentContainer: NSPersistentContainer!
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    public lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    public var defaults: UserDefaults { return CoreDataController.defaults }
    open var resourceKey: String {
        let group = [type(of: self).containerName, "Resource"]
        return group.joined()
    }
    public override init() {
        let cName = type(of: self).containerName
        if let resource = urlForContainer(cName) {
            persistentContainer = CoreDataController.createAtURL(resource, forName: type(of: self).entityName)
        } else {
            persistentContainer = nil
        }
        super.init()
        assert(persistentContainer != nil, "Cannot locate container with name \(cName)")
        persistentContainer.loadPersistentStores(completionHandler: storeLoadComplete)
        viewContext.automaticallyMergesChangesFromParent = true
    }
    @discardableResult public func removeStore() -> Bool {
        let cn = type(of: self).containerName
        defaults.set(false, forKey: resourceKey)
        return CoreDataController.removeStore(cn)
    }
    open func save(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            os_log(.error, log: CDLube.oslog, "Error while saving to core data, %@", error.localizedDescription)
        }
    }
    open func saveContext() {
        save(persistentContainer.viewContext)
    }
    open func storeLoadSuccess() {
        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    private func storeLoadComplete(_ storeDescription: NSPersistentStoreDescription, error: Error?) {
        if let e = error {
            let nserror = e as NSError
            switch nserror.code {
            case NSMigrationMissingSourceModelError:
                guard let storeURL = storeDescription.url else { return }
                os_log(.debug, log: CDLube.oslog, "Migration failed, try deleting %@", storeURL as NSURL)
            default:
                os_log(.debug, log: CDLube.oslog, "Unresolved error %@", nserror)
            }
        } else {
            storeLoadSuccess()
        }
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
    }
    private func containerUsingContainerName(_ containerName: String, entityName: String) -> NSPersistentContainer? {
        guard let resource = urlForContainer(containerName) else { return nil }
        guard let container = CoreDataController.createAtURL(resource, forName: entityName) else { return nil }
        container.loadPersistentStores(completionHandler: storeLoadComplete(_:error:))
        return container
    }
}
