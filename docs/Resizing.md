# Panel resizing
An advanced feature of PanelKit is the ability to resize panels while they are floating.

## How to implement
To implement panel resizing, the PanelContentDelegate of a panel should implement the `minimumPanelContentSize` or/and the `maximumPanelContentSize` API. By default, both of these return the panel's `preferredPanelContentSize`, disabling resizing. When resizing is enabled, a handle will appear in the bottom right corner.

## Example implementation
The following implementation will enable resizing:

```swift
extension MyPanelContentViewController: PanelContentDelegate {

    var preferredPanelContentSize: CGSize {
        return CGSize(width: 320, height: 240)
    }
	
    var minimumPanelContentSize: CGSize {
        return CGSize(width: 300, height: 200)
    }
	
    var maximumPanelContentSize: CGSize {
        return CGSize(width: 480, height: 640)
    }

}
```