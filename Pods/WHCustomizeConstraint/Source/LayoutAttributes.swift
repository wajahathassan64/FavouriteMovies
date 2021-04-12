//    MIT License
//
//    Copyright (c) 2020 Wajahat Hassan <wajahathassan64@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

import Foundation

enum LayoutAxis {
    case vertical
    case horizontal
    case dimensions
}

public enum LayoutEdge {
    case left
    case right
    case top
    case bottom
    case bottomAvoidingKeyboard
    case safeAreaLeft
    case safeAreaRight
    case safeAreaTop
    case safeAreaBottom
    case safeAreaBottomAvoidingKeyboard
    case centerX
    case centerY
    case height
    case width
}

extension LayoutEdge {
    var axis: LayoutAxis {
        switch self {
        case .left, .right, .centerX, .safeAreaLeft, .safeAreaRight:
            return .horizontal
        case .bottom, .top, .centerY, .safeAreaTop, .safeAreaBottom, .bottomAvoidingKeyboard, .safeAreaBottomAvoidingKeyboard:
            return .vertical
        case .height, .width:
            return .dimensions
            
        }
    }
    
    var safeAreaEdge: LayoutEdge {
        switch self {
        case .left, .safeAreaLeft:
            return .safeAreaLeft
        case .top, .safeAreaTop:
            return .safeAreaTop
        case .right, .safeAreaRight:
            return .safeAreaRight
        case .bottom, .safeAreaBottom, .bottomAvoidingKeyboard, .safeAreaBottomAvoidingKeyboard:
            return .safeAreaBottom
        default:
            return .safeAreaLeft
        }
    }
}

public enum LayoutConstantModifier {
    case equalTo
    case lessThanOrEqualTo
    case greaterThanOrEqualTo
}

internal extension UIView {
    func horizontalAnchor(_ edge: LayoutEdge) -> NSLayoutXAxisAnchor {
        switch edge {
        case .left:
            return leadingAnchor
        case .right:
            return trailingAnchor
        case .centerX:
            return centerXAnchor
        case .safeAreaLeft:
            return safeAreaLayoutGuide.leadingAnchor
        case .safeAreaRight:
            return safeAreaLayoutGuide.trailingAnchor
        default:
            return leadingAnchor
        }
    }
    
    func verticalAnchor(_ edge: LayoutEdge) -> NSLayoutYAxisAnchor {
        switch edge {
        case .top:
            return topAnchor
        case .bottom, .bottomAvoidingKeyboard:
            return bottomAnchor
        case .centerY:
            return centerYAnchor
        case .safeAreaTop:
            return safeAreaLayoutGuide.topAnchor
        case .safeAreaBottom, .safeAreaBottomAvoidingKeyboard:
            return safeAreaLayoutGuide.bottomAnchor
        default:
            return topAnchor
        }
    }
    
    func dimensionAnchor(_ edge: LayoutEdge) -> NSLayoutDimension {
        switch edge {
        case .width:
            return widthAnchor
        case .height:
            return heightAnchor
        default:
            return widthAnchor
        }
    }
}
