CHANGELOG
=========

<details>
<summary>Note: This is in reverse chronological order, so newer entries are added to the top.</summary>

| Contents                        |
| :------------------------------ |
| [1.0.0](#100-2017-03-20)        |
| [0.9.0](#090-2017-03-08)        |
| [0.8.2](#082-2017-02-23)        |
| [0.8.1](#081-2017-02-21)        |
| [0.8](#08-2017-02-20)           |

</details>

2.0.0 (TBD)
--------------
* Updated to Swift 4.0
* Requires iOS 10.0 or newer
* Panel resizing 
* Improved documentation
* Added PanelViewController convenience initializer
* Maintain panel at drag position when unpinned
* Respect dragInsets when adjusting panel position for keyboard
* Added preferredPanelPinnedWidth: specifies width for panel while pinned, which can now differ from the panel width while floating
* Fixes UITableViewCell swipe actions on iOS 11
* PanelContentDelegate: add panelDragGestureRecognizer(shouldReceive: touch) API
* Improved debug logging
* Improved performance

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




