//
//  IntArrayValueTransformer.swift
//  CDLube
//
//  Created by Wenzhong Zhang on 2019-08-16.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import os.log
import Foundation

public class IntArrayValueTransformer: ValueTransformer {
    static public let name = NSValueTransformerName(rawValue: "IntArrayValueTransformer")
    public override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    public override class func allowsReverseTransformation() -> Bool {
        return true
    }
    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            return result
        } catch {
            os_log(.error, log: CDLube.oslog, "%@", error.localizedDescription)
            return nil
        }
    }
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let v = value else { return nil }
        do {
            let result = try NSKeyedArchiver.archivedData(withRootObject: v, requiringSecureCoding: true)
            return result
        } catch {
            os_log(.error, log: CDLube.oslog, "%@", error.localizedDescription)
            return nil
        }
    }
}
