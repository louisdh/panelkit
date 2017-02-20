<p align="center">
<img src="readme-resources/hero.png" style="max-height: 300px;" alt="PanelKit for iOS">
</p>

<center>[![Swift](https://img.shields.io/badge/Swift-3.0.2-orange.svg?style=flat")](https://developer.apple.com/swift/)
![platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Twitter](https://img.shields.io/badge/Twitter-@LouisDhauwe-blue.svg?style=flat)](http://twitter.com/LouisDhauwe)
</center>

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


## Requirements

* iOS 9.0+
* Xcode 8.2+


## License

TBD