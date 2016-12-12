//
//  Computr.swift
//  Assemble
//
//  Created by Brian King on 12/11/16.
//  Copyright © 2016 Brian King. All rights reserved.
//

import Foundation

struct Computr {
    static var Empty: Integer = 0
    typealias Integer = Int
    typealias Address = UnsafeMutablePointer<Integer>
    var ic: Address = Address.allocate(capacity: 1)
    var eax: Integer = 0
    var memory = Address.allocate(capacity: 10)

    mutating func addr(at index: Int) -> Address {
        return memory.advanced(by: index)
    }
/* 
     ** This crashes the compiler. I'm guessing I'm doing something wrong.
     ** Also, the fixit is wrong, you can not add mutating -- Fix the bug
    subscript(index: Int) -> Address {
        get {
            return memory.withUnsafeBytes { (bytes) -> Address in
                return UnsafeMutablePointer(mutating: bytes[index])
            }
        }
        set {
            return memory.withUnsafeBytes { (bytes) -> Address in
                bytes[index] = newValue
            }
        }
    }
*/
    struct Instruction {
        enum Operation: Integer {
            case move, add
        }
        let op: Operation
        let from: Address
        let to: Address

        func execute() {
            switch op {
            case .move:
                to.pointee = from.pointee
            case .add:
                to.pointee = to.pointee + from.pointee
            }
        }
    }

    mutating func execute(count: Int) {
        for _ in 0..<count {
            ic.withMemoryRebound(to: Instruction.self, capacity: 1) { buff in
                buff.pointee.execute()
            }
            ic = ic.advanced(by: MemoryLayout<Instruction>.size)
        }
    }
}
