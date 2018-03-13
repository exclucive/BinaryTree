//: Playground - noun: a place where people can play

import UIKit

// insert
// delete
// remove
// inorder, preorder, postorder traversal

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}

public class BinarySearchTree<T: Comparable> {
    let value: T
    var parent: BinarySearchTree<T>?
    var left: BinarySearchTree<T>?
    var right: BinarySearchTree<T>?
    
    init(value: T) {
        self.value = value
    }

    init(values: [T]) {
        precondition(values.count > 0)
        
        value = values.last!
    
        for value in values.dropLast() {
            insert(value: value)
        }
    }
    
    public func insert(value: T) {
        // go left
        if value < self.value {
            if let leftNode = left {
                leftNode.insert(value: value)
            } else {
                let newNode = BinarySearchTree(value: value)
                newNode.parent = self
                left = newNode
            }
        }
        // go right
        else {
            if let rightNode = right {
                rightNode.insert(value: value)
            } else {
                let newNode = BinarySearchTree(value: value)
                newNode.parent = self
                right = newNode
            }
        }
    }
    
    public func search(value: T) -> BinarySearchTree? {
        if value < self.value {
            return left?.search(value: value)
        } else if value > self.value {
            return right?.search(value: value)
        } else {
            return self
        }
    }
    
    public func preOrderTraversal(_ process: (BinarySearchTree) -> Void) {
        process(self)
        left?.preOrderTraversal(process)
        right?.preOrderTraversal(process)
    }
    
    public func inOrderTraversal(_ process: (BinarySearchTree) -> Void) {
        left?.inOrderTraversal(process)
        process(self)
        right?.inOrderTraversal(process)
    }
    
    public func postOrderTraversal(_ process: (BinarySearchTree) -> Void) {
        left?.postOrderTraversal(process)
        right?.postOrderTraversal(process)
        process(self)
    }
    
    @discardableResult public func remove() -> BinarySearchTree? {
        let replacementNode:BinarySearchTree?
        
        if let leftNode = left {
            replacementNode = leftNode.findMax()
        }
        else if let rightNode = right {
            replacementNode = rightNode.findMin()
        }
        else {
            replacementNode = nil
        }
        
        replacementNode?.remove()
        replacementNode?.left = left
        replacementNode?.right = right
        
        right?.parent = replacementNode
        left?.parent = replacementNode
        
        reconnectParentToNode(node: replacementNode)
        
        parent = nil
        left = nil
        right = nil
        
        return replacementNode
    }
    
    // private methods
    private func reconnectParentToNode(node: BinarySearchTree?) {
        if let parent = parent {
            if isLeft() {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
    
    private func findMax() -> BinarySearchTree? {
        if isLeaf() {
            return self
        }
        else {
            return right?.findMax()
        }
    }
    
    private func findMin() -> BinarySearchTree? {
        if isLeaf() {
            return self
        }
        else {
            return left?.findMin()
        }
    }
    
    private func isLeft() -> Bool {
        return parent?.left === self
    }
    
    private func isRight() -> Bool {
        return parent?.right === self
    }
    
    private func isLeaf() -> Bool {
        return left == nil && right == nil
    }
    
    private func isRoot() -> Bool {
        return parent == nil
    }
}

let tree = BinarySearchTree<Int>(values: [7, 2, 5, 10, 9, 1])
let node = tree.search(value: 10)
print(node)
node?.remove()
print(tree)
