# Multi-pinning
An advanced feature of PanelKit is the ability to have multiple panels pinned to the same side. 

## How to implement
To implement multi-pinning, a PanelManager should implement the `maximumNumberOfPanelsPinned(at side: PanelPinSide)` function and return a value greater than 1. By default, this API returns 1, which disabled the feature.

## Example implementation
The following example will calculate the maximum number of pinned panels based on the available height:

```swift
public func maximumNumberOfPanelsPinned(at side: PanelPinSide) -> Int {
    return Int(floor(self.view.bounds.height / 320))
}
```

## Pinned size
When multiple panels are pinned to the same side, they each have the same height. 

The width is determined by the earliest panel pinned. For example: when a panel is pinned to the right side, the width of the pinned area is the panel's `preferredPanelPinnedWidth`. When a second panel is pinned to the right side, the width of the pinned area stays the same. When the first panel is unpinned, the width of the remaining pinned panel is updated to its `preferredPanelPinnedWidth`.