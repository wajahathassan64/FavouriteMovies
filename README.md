# Favourite Movies Code Challenge

[![CI Status](https://img.shields.io/travis/wajahathassan64/WHCustomizeConstraint.svg?style=flat)](https://travis-ci.org/wajahathassan64/WHCustomizeConstraint)
[![Version](https://img.shields.io/cocoapods/v/WHCustomizeConstraint.svg?style=flat)](https://cocoapods.org/pods/WHCustomizeConstraint)
[![License](https://img.shields.io/cocoapods/l/WHCustomizeConstraint.svg?style=flat)](https://cocoapods.org/pods/WHCustomizeConstraint)
[![Platform](https://img.shields.io/cocoapods/p/WHCustomizeConstraint.svg?style=flat)](https://cocoapods.org/pods/WHCustomizeConstraint)


## Features
<ul>
<li>Cheetay Code Challenge Assignment Features.</li>
<li>Movie in collection view.</li>
<li>Store favourite movies.</li>
<li>Remove favourite movies.</li>
<li>Favourite movies list using tableView.</li>
<li>Movies in grid support pagination.</li>
</ul>

## Installation

WHCustomizeConstraint is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WHCustomizeConstraint'
```

WHCustomizeConstraint is available through [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```ruby
github 'wajahathassan64/WHCustomizeConstraint'
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory. Furthermore, some useful examples described below.

### Align Edges

Attaching any `UI component` to its superview with `NSLayoutConstraint`:

```ruby
NSLayoutConstraint.activate([
view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0),
view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0),
view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0),
view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0)
])
```

with `WHCustomizeConstraint`:

```ruby
view.alignAllEdgesWithSuperview()
```

or:

```ruby
view.alignEdgesWithSuperview([.left, .right, .top, .bottom], constants: [0,0,0,0]) 
```
### Center in Superview

Keeping a view `(UI-component)` to the center of its superview with `NSLayoutConstraint`:

```ruby
NSLayoutConstraint.activate([
view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0)
view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0)
])
```

with `WHCustomizeConstraint`:

```ruby
view.centerInSuperView()
```

# Usage 

## Constraints with Superview

### Center Horizontally in Superview

Constraining a view `Horizontally` to the center of its supperview with `WHCustomizeConstraint`:

```ruby
view.centerHorizontallyInSuperview()
```

### Center Vertically in Superview

Constraining a view `Vertically` to the center of its supperview with `WHCustomizeConstraint`:

```ruby
view.centerVerticallyInSuperview()
```

### Edge Superview Safe Area

Attaching a view with superview SafeArea with padding using `WHCustomizeConstraint`:

```ruby
view.alignEdgeWithSuperviewSafeArea(.top, constant: 10)
```

### Top to Bottom & Bottom to Top

This constraints the top-anchor of `secondView` to the bottom-anchor of `firstView`:

```ruby
secondView.topToBottom(firstView)
or
secondView.topToBottom(firstView, constant: 10)
```
This constraints the bottom-anchor of `firstView` to the top-anchor of `secondView`:

```ruby
firstView.bottomToTop(secondView)
or
firstView.bottomToTop(secondView, constant: 10)
```

## Author

wajahathassan64, wajahathassan64@gmail.com

## License

WHCustomizeConstraint is available under the MIT license. See the LICENSE file for more info.
