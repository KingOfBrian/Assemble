//
//  Computer.swift
//  Assemble
//
//  Created by Brian King on 12/10/16.
//  Copyright © 2016 Brian King. All rights reserved.
//

import Foundation

enum RegisterType { case float, integer, programCounter }

struct Register {
    let type: RegisterType = .integer
    let name: String
    var value: String
}

enum Instruction {
    enum Value {
        case register(name: String)
        case constant(String)
        case address(String)
        case empty
    }
    case add(Value, Value)
    case load(address: String)
}

struct Code {
    var module: String
    var function: String
    var instructions: [Instruction]
}
