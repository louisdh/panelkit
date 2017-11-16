# State restoring
An advanced feature of PanelKit is the ability to save and restore the state of panels. This allows you to save all the floating and pinned states at a particular moment in your app's life, store it (e.g. to disk), and restore to the exact same state at any moment.

## How to implement
### Panels
Each panel that wants its state to be able to save and restore needs to implement the `PanelStateCoder` protocol. This procotol has one single requirement:

```swift
var panelId: Int { get }
```

`panelId` is a unique id to identify a panel. Used when restoring the panel’s state.
A panel’s id should be the same across app launches to successfully restore its state.

### PanelManager
#### Saving
The PanelManager protocol has the following API:

```swift
var panelStates: [Int: PanelState] { get }
```

This returns a dictionary with the panel ids as keys and panel states as values. The `PanelState` struct conforms to the `Codable` protocol.

#### Restoring

Restoring can be done via the following API:

```swift
func restorePanelStates(_ states: [Int: PanelState])
```

## Example implementation

```swift
extension MyPanelManager {

    func savePanelStates() {

        let states = self.panelStates
		
        let encoder = JSONEncoder()
		
        guard let json = try? encoder.encode(states) else {
            return
        }
		
        UserDefaults.standard.set(json, forKey: "panelStates")
		
    }
	
    func restorePanelStatesFromDisk() {
		
        guard let jsonData = UserDefaults.standard.data(forKey: "panelStates") else {
            return
        }
		
        let decoder = JSONDecoder()
        guard let states = try? decoder.decode([Int: PanelState].self, from: jsonData) else {
            return
        }
		
        restorePanelStates(states)
		
    }
	
}
```