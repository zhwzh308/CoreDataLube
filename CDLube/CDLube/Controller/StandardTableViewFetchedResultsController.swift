//
//  StandardTableViewFetchedResultsController.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import CoreData
import UIKit

open class StandardTableViewFetchedResultsController: NSObject, NSFetchedResultsControllerDelegate {
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet public weak var delegate: NSFetchedResultsControllerDelegate?
    @IBInspectable public var ignoresectionIndexTitle: Bool = false
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let delegate = delegate, delegate.responds(to: #selector(controllerWillChangeContent(_:))) {
            delegate.controllerWillChangeContent?(controller)
        } else {
            guard let tv = tableView else { return }
            tv.beginUpdates()
        }
    }
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if let delegate = delegate, delegate.responds(to: #selector(controller(_:didChange:atSectionIndex:for:))) {
            delegate.controller?(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
        } else {
            guard let tv = tableView else { return }
            let si = IndexSet(integer: sectionIndex),
            sections: FadeSections?
            switch type {
            case .insert:
                sections = .insert(si)
            case .delete:
                sections = .delete(si)
            case .update:
                sections = .reload(si)
            default:
                sections = nil
            }
            sections?.perform(tv)
        }
    }
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let delegate = delegate, delegate.responds(to: #selector(controller(_:didChange:at:for:newIndexPath:))) {
            delegate.controller?(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
        } else {
            guard let tv = tableView else { return }
            let fade: FadeRow
            switch type {
            case .insert:
                guard let ip = newIndexPath else { return }
                fade = .insert(ip)
            case .delete:
                guard let ip = indexPath else { return }
                fade = .delete(ip)
            case .move:
                guard let ip = indexPath, let nip = newIndexPath else { return }
                fade = .move(ip, nip)
            case .update:
                guard let ip = indexPath else { return }
                fade = .reload(ip)
            @unknown default: return
            }
            fade.perform(with: tv)
        }
    }
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let delegate = delegate, delegate.responds(to: #selector(controllerDidChangeContent(_:))) {
            delegate.controllerDidChangeContent?(controller)
        } else {
            guard let tv = tableView else { return }
            tv.endUpdates()
        }
    }
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        if ignoresectionIndexTitle {
            return nil
        }
        if let delegate = delegate, delegate.responds(to: #selector(controllerWillChangeContent(_:))) {
            return delegate.controller?(controller, sectionIndexTitleForSectionName: sectionName)
        }
        return sectionName
    }
}
