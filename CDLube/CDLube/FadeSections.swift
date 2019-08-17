//
//  FadeSections.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import UIKit

enum FadeSections: TableViewPerformable {
    case insert(IndexSet), delete(IndexSet), reload(IndexSet)
    func perform(_ tableView: UITableView) {
        switch self {
        case .insert(let indexSet):
            tableView.insertSections(indexSet, with: .fade)
        case .delete(let indexSet):
            tableView.deleteSections(indexSet, with: .fade)
        case .reload(let indexSet):
            tableView.reloadSections(indexSet, with: .fade)
        }
    }
}

public enum FadeRow {
    case insert(IndexPath), move(IndexPath, IndexPath), delete(IndexPath), reload(IndexPath)
    var rows: FadeRows {
        switch self {
        case .insert(let row):
            return .insert([row])
        case .move(let fromRow, let toRow):
            return .move([fromRow], [toRow])
        case .delete(let row):
            return .delete([row])
        case .reload(let row):
            return .reload([row])
        }
    }
    public func perform(with tableView: UITableView) {
        rows.perform(tableView)
    }
}

public enum FadeRows: TableViewPerformable {
    case insert([IndexPath]), move([IndexPath], [IndexPath]), delete([IndexPath]), reload([IndexPath])
    public func perform(_ tableView: UITableView) {
        switch self {
        case .insert(let rows):
            tableView.insertRows(at: rows, with: .fade)
        case .delete(let rows):
            tableView.deleteRows(at: rows, with: .fade)
        case .move(let fromRows, let toRows):
            let actions: [FadeRows] = [.delete(fromRows), .insert(toRows)]
            actions.batch(tableView: tableView)
        case .reload(let rows):
            tableView.reloadRows(at: rows, with: .fade)
        }
    }
    static func batch(_ actions: [FadeRows], tableView: UITableView) {
        tableView.performBatchUpdates({
            actions.batch(tableView: tableView)
        }, completion: nil)
    }
}

extension Array where Element: TableViewPerformable {
    func batch(tableView: UITableView) {
        forEach{$0.perform(tableView)}
    }
}
