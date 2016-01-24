//
//  AnimationLock.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 1/25/16.
//  Copyright © 2016 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

class AnimationLock {
    private var from: Int?
    private var to: Int?
    private let lock = NSRecursiveLock()

    func lock(from: Int, to: Int) {
        lock.lock()
        defer { lock.unlock() }
        self.from = from
        self.to = to
    }

    func unlock() {
        lock.lock()
        defer { lock.unlock() }
        self.from = nil
        self.to = nil
    }

    func isLock(from: Int, to: Int) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        if self.from == from && self.to == to {
            return true
        }

        return false
    }
}
