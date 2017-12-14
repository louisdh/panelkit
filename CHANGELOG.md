CHANGELOG
=========

<details>
<summary>Note: This is in reverse chronological order, so newer entries are added to the top.</summary>

| Contents                        |
| :------------------------------ |
| [2.0.1](#201-2017-12-14)        |
| [2.0.0](#200-2017-12-05)        |
| [1.0.0](#100-2017-03-20)        |
| [0.9.0](#090-2017-03-08)        |
| [0.8.2](#082-2017-02-23)        |
| [0.8.1](#081-2017-02-21)        |
| [0.8](#08-2017-02-20)           |

</details>

[2.0.1](https://github.com/louisdh/panelkit/tree/2.0.1) (2017-12-14)
--------------
* Fixed an animation glitch when unpinning a panel

[2.0.0](https://github.com/louisdh/panelkit/tree/2.0.0) (2017-12-05)
--------------
* Multi-pinning, pin multiple panels to a side
* Panel resizing
* State restoring, save and load panel states
* Added APIs to pin or float a panel, without the use of a popover
* Improved documentation
* Updated to Swift 4.0
* Added PanelViewController convenience initializer
* Maintain panel at drag position when unpinned
* Respect dragInsets when adjusting panel position for keyboard
* Added preferredPanelPinnedWidth API: specifies width for panel while pinned, which can now differ from the panel width while floating
* Fixes UITableViewCell swipe actions on iOS 11
* PanelContentDelegate: add panelDragGestureRecognizer(shouldReceive: touch) API
* Improved debug logging
* Improved performance
* Removed iOS 9 support (iOS 10.0 or newer is now required)

[1.0.0](https://github.com/louisdh/panelkit/tree/1.0.0) (2017-03-20)
--------------
* Replaced ```PanelContentViewController``` with ```PanelContentDelegate``` protocol.
* Fixed memory leaks.
* Added unit tests.

[0.9.0](https://github.com/louisdh/panelkit/tree/0.9.0) (2017-03-08)
--------------
* Introduced exposé with optional double 3 finger tap gesture recognizer to active.
* Reduced public API.
* Moved panel state properties from ```PanelContentViewController``` to ```PanelViewController```.

[0.8.2](https://github.com/louisdh/panelkit/tree/0.8.2) (2017-02-23)
--------------

* Fixed pinned panel preview views that weren't ever removed
* ```panelContentView``` now supports a top and bottom margin other than 0

[0.8.1](https://github.com/louisdh/panelkit/tree/0.8.1) (2017-02-21)
--------------

*  Updated documentation

[0.8](https://github.com/louisdh/panelkit/tree/0.8) (2017-02-20)
------------

* Initial release with support for floating and pinned panels.




