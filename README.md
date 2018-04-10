<p align="center">
<img src="readme-resources/hero.png" style="max-height: 300px;" alt="PanelKit for iOS">
</p>

<p align="center">
<a href="https://travis-ci.org/louisdh/panelkit"><img src="https://travis-ci.org/louisdh/panelkit.svg?branch=master" style="max-height: 300px;" alt="Build Status"/></a>
<a href="https://codecov.io/gh/louisdh/panelkit"><img src="https://codecov.io/gh/louisdh/panelkit/branch/master/graph/badge.svg" alt="Codecov"/></a>
<br>
<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat" style="max-height: 300px;" alt="Swift"/></a>
<a href="https://cocoapods.org/pods/PanelKit"><img src="https://img.shields.io/cocoapods/v/PanelKit.svg" style="max-height: 300px;" alt="PodVersion"/></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4bc51d.svg?style=flat" style="max-height: 300px;" alt="Carthage Compatible"/></a>
<img src="https://img.shields.io/badge/platform-iOS-lightgrey.svg" style="max-height: 300px;" alt="Platform: iOS">
<br>
<a href="http://twitter.com/LouisDhauwe"><img src="https://img.shields.io/badge/Twitter-@LouisDhauwe-blue.svg?style=flat" style="max-height: 300px;" alt="Twitter"/></a>
<a href="https://paypal.me/louisdhauwe"><img src="https://img.shields.io/badge/Donate-PayPal-green.svg?style=flat" alt="Donate via PayPal"/></a>
</p>

<p align="center">
<img src="readme-resources/example.gif" style="max-height: 4480px;" alt="PanelKit for iOS">
<br>
<i>Applications using PanelKit can be seen in the <a href="SHOWCASE.md">showcase</a>.</i>
</p>


## About
PanelKit is a UI framework that enables panels on iOS. A panel can be presented in the following ways:

* Modally
* As a popover
* Floating (drag the panel around)
* Pinned (either left or right)


This framework does all the heavy lifting for dragging panels, pinning them and even moving/resizing them when a keyboard is shown/dismissed.


## Implementing
A lot of effort has gone into making the API simple for a basic implementation, yet very customizable if needed. Since PanelKit is protocol based, you don't need to subclass anything in order to use it. There a two basic principles PanelKit entails: ```panels``` and a ```PanelManager```.

### Panels
A panel is created using the ```PanelViewController``` initializer, which expects a ```UIViewController```, ```PanelContentDelegate``` and ```PanelManager```.

#### PanelContentDelegate
```PanelContentDelegate ``` is a protocol that defines the appearance of a panel. Typically the ```PanelContentDelegate ``` protocol is implemented for each panel on its ```UIViewController```.


Example:

```swift
class MyPanelContentViewController: UIViewController, PanelContentDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Panel title"	
    }
    
    var preferredPanelContentSize: CGSize {
        return CGSize(width: 320, height: 500)
    }	
}
```  

A panel is explicitly (without your action) shown in a ```UINavigationController```, but the top bar can be hidden or styled as with any ```UINavigationController```.


### PanelManager
```PanelManager``` is a protocol that in its most basic form expects the following:

```swift
// The view in which the panels may be dragged around
var panelContentWrapperView: UIView {
    return contentWrapperView
}

// The content view, which will be moved/resized when panels pin
var panelContentView: UIView {
    return contentView
}

// An array of PanelViewController objects
var panels: [PanelViewController] {
    return []
}
``` 

Typically the ```PanelManager``` protocol is implemented on a ```UIViewController```.

## Advanced features
PanelKit has some advanced opt-in features:

* [Multi-pinning](docs/MultiPinning.md)
* [Panel resizing](docs/Resizing.md)
* [State restoration](docs/States.md)
* [Exposé](docs/Expose.md)

## Installation

### [CocoaPods](http://cocoapods.org)

To install, add the following line to your ```Podfile```:

```ruby
pod 'PanelKit', '~> 2.0'
```

### [Carthage](https://github.com/Carthage/Carthage)
To install, add the following line to your ```Cartfile```:

```ruby
github "louisdh/panelkit" ~> 2.0
```
Run ```carthage update``` to build the framework and drag the built ```PanelKit.framework``` into your Xcode project.



## Requirements

* iOS 10.0+
* Xcode 9.0+

## Todo 

### Long term:
- [ ] Top/down pinning

## License

This project is available under the MIT license. See the LICENSE file for more info.
