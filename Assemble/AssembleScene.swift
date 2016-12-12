//
//  AssembleScene.swift
//  Assemble
//
//  Created by Brian King on 12/9/16.
//  Copyright © 2016 Brian King. All rights reserved.
//

import SceneKit

class AssembleScene: SCNScene {

    override init() {
        super.init()
        let threadNode = ThreadNode()
        let _ = [
            threadNode.registerSet,
        ]
        rootNode.addChildNode(threadNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addDefaults() {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        ambientLightNode.light?.intensity = 1
        rootNode.addChildNode(ambientLightNode)
    }

}

extension SCNNode {
    func children<T: SCNNode>(of type: T.Type) -> [T] {
        return childNodes.map { $0 as? T }.flatMap { $0 }
    }

    func configureChild<T: SCNNode>(with constructor: @autoclosure (Void) -> T) -> T {
        let node = constructor()
        addChildNode(node)
        return node
    }
}

protocol Layoutable {
    func layoutSubNodes()
    func setNeedsLayout()
}
extension Layoutable {
    func layoutSubNodes() {}
    func setNeedsLayout() {}
}

class ThreadNode: SCNNode {
    lazy var registerSet: RegisterSetNode = { return self.configureChild(with: RegisterSetNode()) }()
}

class RegisterSetNode: SCNNode, Layoutable {
    lazy var pc:  RegisterNode = { return self.configureChild(with: RegisterNode(registerName: "pc", color: .red)) }()
    lazy var ic:  RegisterNode = { return self.configureChild(with: RegisterNode(registerName: "ic", color: .green)) }()
    lazy var acc: RegisterNode = { return self.configureChild(with: RegisterNode(registerName: "acc", color: .blue)) }()

    override init() {
        super.init()
        let box = SCNBox(width: 8, height: 0.5, length: 2, chamferRadius: 0)
        geometry = box
        pc.position = .init(-2.5, 1, 0)
        ic.position = .init(0, 1, 0)
        acc.position = .init(2.5, 1, 0)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
}

extension SCNText {
    class func register(with text: String) -> SCNText {
        let text = SCNText(string: text, extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 1)
        text.alignmentMode = kCAAlignmentCenter
        text.containerFrame = .init(x: 0, y: 0, width: 2, height: 2)
        return text
    }
}

class RegisterNode: SCNNode, Layoutable {
    let registerName: String
    var value: String? {
        didSet {
        }
    }

    lazy var registerTextNode: SCNNode = {
        let textNode = SCNNode()
        self.addChildNode(textNode)
        return textNode
    }()

    init(registerName: String, color: UIColor) {
        self.registerName = registerName
        super.init()
        let box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0.1)
        func material() -> SCNMaterial {
            let material = SCNMaterial()
            material.diffuse.contents = color
            return material
        }
        box.materials = [
            material(),
            material(),
            material(),
            material(),
            material(),
            material(),
        ]
        registerTextNode.geometry = SCNText.register(with: registerName)
        registerTextNode.position = .init(-1, -1, 1)

        geometry = box
        scale = .init(0.8, 0.8, 0.8)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
}

class InstructionNode: SCNNode {
    let instructionName: String

    init(instructionName: String) {
        self.instructionName = instructionName
        super.init()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
}

class InstructionListNode: SCNNode {
    let index: Int = 0

    func addInstruction(name: String) {
    }
}

