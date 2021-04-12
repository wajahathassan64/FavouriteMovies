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

// MARK: All edges constraints

public extension UIView {
    @discardableResult func alignEdges(_ edges: [LayoutEdge], withView view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        for edge in edges {
            _ = alignEdge(edge, withView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
        }
        
        return self
    }
    
    @discardableResult func alignEdges(_ edges: [LayoutEdge], withView view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constants: [CGFloat], priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        for edge in edges {
            _ = alignEdge(edge, withView: view, constantModifier, constant: constants[edges.firstIndex(of: edge) ?? 0], priority: priority, isActive: isActive)
        }
        
        return self
    }
}

// MARK: Dimension constraints

public extension UIView {
    @discardableResult func width(_ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        let constraint: NSLayoutConstraint
        
        switch constantModifier {
        case .equalTo:
            constraint = widthAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqualTo:
            constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqualTo:
            constraint = widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        
        constraint.priority = priority
        constraint.isActive = isActive
        return self
    }
    
    @discardableResult func height(_ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        let constraint: NSLayoutConstraint
        
        switch constantModifier {
        case .equalTo:
            constraint = heightAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqualTo:
            constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqualTo:
            constraint = heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        
        constraint.priority = priority
        constraint.isActive = isActive
        return self
    }
    
    @discardableResult func height(with edge: LayoutEdge, _ constantModifier: LayoutConstantModifier = .equalTo, ofView view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        return pinDimensionEdge(.height, toEdge: edge, ofView: view, constantModifier, mutliplier: multiplier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func width(with edge: LayoutEdge, _ constantModifier: LayoutConstantModifier = .equalTo, ofView view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        return pinDimensionEdge(.width, toEdge: edge, ofView: view, constantModifier, mutliplier: multiplier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func aspectRatio(_ ratio: CGFloat = 1, _ priority:UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return height(with: .width, ofView: self, multiplier: ratio, priority: priority, isActive: isActive)
    }
}

// MARK: Constraints with superview

public extension UIView {
    @discardableResult func centerInSuperView(priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        guard let superview = superview else { return self }
        return alignCenterWith(superview, isActive: isActive)
    }
    
    @discardableResult func centerHorizontallyInSuperview(priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        guard let superview = superview else { return self }
        return horizontallyCenterWith(superview, isActive: isActive)
    }
    
    @discardableResult func centerVerticallyInSuperview(priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        guard let superview = superview else { return self }
        return verticallyCenterWith(superview, isActive: isActive)
    }
    
    @discardableResult func alignEdgeWithSuperview(_ edge: LayoutEdge, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        guard let superview = superview else { return self }
        return alignEdge(edge, withView: superview, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func alignEdgeWithSuperviewSafeArea(_ edge: LayoutEdge, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        guard let superview = superview else { return self }
        return pinEdge(edge, toEdge: edge.safeAreaEdge, ofView: superview, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func alignAllEdgesWithSuperview(_ constantModifier: LayoutConstantModifier = .equalTo, edgeInsets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return alignEdgeWithSuperview(.left, constantModifier, constant: edgeInsets.left, priority: priority, isActive: isActive)
            .alignEdgeWithSuperview(.top, constantModifier, constant: edgeInsets.top, priority: priority, isActive: isActive)
            .alignEdgeWithSuperview(.right, constantModifier, constant: edgeInsets.right, priority: priority, isActive: isActive)
            .alignEdgeWithSuperview(.bottom, constantModifier, constant: edgeInsets.bottom, priority: priority, isActive: isActive)
    }
    
    @discardableResult func alignEdgesWithSuperview(_ edges: [LayoutEdge], _ constantModifier: LayoutConstantModifier = .equalTo, constants: [CGFloat], priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        guard let superview = superview else { return self }
        
        return alignEdges(edges, withView: superview, constantModifier, constants: constants, priority: priority, isActive: isActive)
    }
    
    @discardableResult func alignEdgesWithSuperview(_ edges: [LayoutEdge], _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        guard let superview = superview else { return self }
        
        return alignEdges(edges, withView: superview, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
}

public extension UIView {
    @discardableResult func toLeftOf(_ view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return pinEdge(.right, toEdge: .left, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func toRightOf(_ view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return pinEdge(.left, toEdge: .right, ofView: view, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func bottomToTop(_ view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return pinEdge(.bottom, toEdge: .top, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func topToBottom(_ view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return pinEdge(.top, toEdge: .bottom, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func alignCenterWith(_ view: UIView, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return horizontallyCenterWith(view, isActive: isActive).verticallyCenterWith(view, isActive: isActive)
    }
    
    @discardableResult func horizontallyCenterWith(_ view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return pinEdge(.centerX, toEdge: .centerX, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func verticallyCenterWith(_ view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return pinEdge(.centerY, toEdge: .centerY, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func alignEdge(_ edge: LayoutEdge, withView view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        return pinEdge(edge, toEdge: edge, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
    }
    
    @discardableResult func pinEdge(_ edge1: LayoutEdge, toEdge edge2: LayoutEdge, ofView view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        if edge1.axis != edge2.axis {
            assertionFailure("Layout Error: all edges of same constraint must be of same axis")
        }
        
        switch edge1.axis {
        case .horizontal:
            return pinHorizontalEdge(edge1, toEdge: edge2, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
        case .vertical:
            return pinVerticalEdge(edge1, toEdge: edge2, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
        case .dimensions:
            return pinDimensionEdge(edge1, toEdge: edge2, ofView: view, constantModifier, constant: constant, priority: priority, isActive: isActive)
        }
    }
}

// MARK: Private @discardableResult functions

private extension UIView {
    @discardableResult func pinHorizontalEdge(_ edge1: LayoutEdge, toEdge edge2: LayoutEdge, ofView view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        let constraint: NSLayoutConstraint
        
        if edge1 != .right && edge1 != .safeAreaRight {
            switch constantModifier {
            case .equalTo:
                constraint = horizontalAnchor(edge1).constraint(equalTo: view.horizontalAnchor(edge2), constant: constant)
            case .greaterThanOrEqualTo:
                constraint = horizontalAnchor(edge1).constraint(greaterThanOrEqualTo: view.horizontalAnchor(edge2), constant: constant)
            case .lessThanOrEqualTo:
                constraint = horizontalAnchor(edge1).constraint(lessThanOrEqualTo: view.horizontalAnchor(edge2), constant: constant)
            }
        } else {
            switch constantModifier {
            case .equalTo:
                constraint = view.horizontalAnchor(edge2).constraint(equalTo: horizontalAnchor(edge1), constant: constant)
            case .greaterThanOrEqualTo:
                constraint = view.horizontalAnchor(edge2).constraint(greaterThanOrEqualTo: horizontalAnchor(edge1), constant: constant)
            case .lessThanOrEqualTo:
                constraint = view.horizontalAnchor(edge2).constraint(lessThanOrEqualTo: horizontalAnchor(edge1), constant: constant)
            }
        }
        
        constraint.priority = priority
        constraint.isActive = isActive
        
        return self
    }
    
    @discardableResult func pinVerticalEdge(_ edge1: LayoutEdge, toEdge edge2: LayoutEdge, ofView view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        let constraint: NSLayoutConstraint
        
        if edge1 != .bottom && edge1 != .safeAreaBottom && edge1 != .bottomAvoidingKeyboard && edge2 != .safeAreaBottomAvoidingKeyboard {
            switch constantModifier {
            case .equalTo:
                constraint = verticalAnchor(edge1).constraint(equalTo: view.verticalAnchor(edge2), constant: constant)
            case .greaterThanOrEqualTo:
                constraint = verticalAnchor(edge1).constraint(greaterThanOrEqualTo: view.verticalAnchor(edge2), constant: constant)
            case .lessThanOrEqualTo:
                constraint = verticalAnchor(edge1).constraint(lessThanOrEqualTo: view.verticalAnchor(edge2), constant: constant)
            }
        } else {
            switch constantModifier {
            case .equalTo:
                constraint = view.verticalAnchor(edge2).constraint(equalTo: verticalAnchor(edge1), constant: constant)
            case .greaterThanOrEqualTo:
                constraint = view.verticalAnchor(edge2).constraint(greaterThanOrEqualTo: verticalAnchor(edge1), constant: constant)
            case .lessThanOrEqualTo:
                constraint = view.verticalAnchor(edge2).constraint(lessThanOrEqualTo: verticalAnchor(edge1), constant: constant)
            }
        }
        
        if edge1 == .safeAreaBottomAvoidingKeyboard || edge1 == .bottomAvoidingKeyboard || edge2 == .bottomAvoidingKeyboard || edge2 == .safeAreaBottomAvoidingKeyboard {
            constraint.identifier = "keyboardAvoidingConstraint"
        }
        
        constraint.priority = priority
        constraint.isActive = isActive
        
        return self
    }
    
    @discardableResult func pinDimensionEdge(_ edge1: LayoutEdge, toEdge edge2: LayoutEdge, ofView view: UIView, _ constantModifier: LayoutConstantModifier = .equalTo, mutliplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> UIView {
        
        let constraint: NSLayoutConstraint
        
        switch constantModifier {
        case .equalTo:
            constraint = dimensionAnchor(edge1).constraint(equalTo: view.dimensionAnchor(edge2), multiplier: mutliplier, constant: constant)
        case .greaterThanOrEqualTo:
            constraint = dimensionAnchor(edge1).constraint(greaterThanOrEqualTo: view.dimensionAnchor(edge2), multiplier: mutliplier, constant: constant)
        case .lessThanOrEqualTo:
            constraint = dimensionAnchor(edge1).constraint(lessThanOrEqualTo: view.dimensionAnchor(edge2), multiplier: mutliplier, constant: constant)
        }
        
        constraint.priority = priority
        constraint.isActive = isActive
        
        return self
    }
    
}
