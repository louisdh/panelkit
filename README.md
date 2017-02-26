<p align="center">
<img src="readme-resources/hero.png" style="max-height: 300px;" alt="PanelKit for iOS">
</p>

<p align="center">

<a href="https://travis-ci.org/louisdh/panelkit"><img src="https://travis-ci.org/louisdh/panelkit.svg?branch=master" style="max-height: 300px;" alt="Build Status"></a>

<a href="https://codeclimate.com/github/louisdh/panelkit"><img src="https://codeclimate.com/github/louisdh/panelkit/badges/gpa.svg" style="max-height: 300px;" alt="Code Climate"></a>

<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-3.0.2-orange.svg?style=flat" style="max-height: 300px;" alt="Swift"></a>

<a href="https://cocoapods.org/pods/PanelKit"><img src="https://img.shields.io/cocoapods/v/PanelKit.svg" style="max-height: 300px;" alt="PodVersion"></a>

<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" style="max-height: 300px;" alt="Carthage Compatible"></a>

<img src="https://img.shields.io/badge/platform-iOS-lightgrey.svg" style="max-height: 300px;" alt="Platform: iOS">

<a href="http://twitter.com/LouisDhauwe"><img src="https://img.shields.io/badge/Twitter-@LouisDhauwe-blue.svg?style=flat" style="max-height: 300px;" alt="Twitter"></a>

</p>

<p align="center">
<img src="readme-resources/example.gif" style="max-height: 4480px;" alt="PanelKit for iOS">
</p>

## About
PanelKit is a UI framework that enables panels on iOS. A panel can be presented in the following ways:

* Modally
* As a popover
* Floating (drag the panel around)
* Pinned (either left or right)


This framework does all the heavy lifting for dragging panels, pinning them and even moving/resizing them when a keyboard is shown/dismissed.


## Implementing
A lot of effort has gone into making the API simple for a basic implementation, yet very customizable if needed. There a two basic principles PanelKit entails: ```panels``` and a ```PanelManager```.

###Panels
A panel is created using the ```PanelViewController``` initializer, which expects a ```PanelContentViewController``` and a ```PanelManager```.

####PanelContentViewController
A ```PanelContentViewController``` is a ```UIViewController``` that needs to be subclassed for each of the desired panels in your application. 

Example:

```swift
class MyPanelContentViewController: PanelContentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Panel title"	
    }
    
    override var preferredPanelContentSize: CGSize {
        return CGSize(width: 320, height: 500)
    }	
}
```  

A panel is explicitly (without your action) shown in a ```UINavigationController```, but the top bar can be hidden or styled as with any ```UINavigationController```.


###PanelManager
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

## Installation

### [CocoaPods](http://cocoapods.org)

To install, add the following line to your ```Podfile```:

```ruby
pod 'PanelKit', '~> 0.8'
```

### [Carthage](https://github.com/Carthage/Carthage)
To install, add the following line to your ```Cartfile```:

```ruby
github "louisdh/panelkit" ~> 0.8
```
Run ```carthage update``` to build the framework and drag the built ```PanelKit.framework``` into your Xcode project.



## Requirements

* iOS 9.0+
* Xcode 8.2+

## Todo 
### Before v1.0:
- [ ] Make ```PanelContentViewController``` a protocol (no more subclassing needed)
- [ ] Exposé
- [ ] Unit tests

### Long term:
- [ ] Panel resizing
- [ ] Top/down pinning


## License

This project is available under the MIT license. See the LICENSE file for more info.
