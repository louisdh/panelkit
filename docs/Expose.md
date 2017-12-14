# Exposé
An advanced feature of PanelKit is Exposé, which shows all floating and pinned panels in an overview, blurring the content behind it.

## How to implement
One way to activate exposé is by calling `enableTripleTapExposeActivation()` on your `PanelManager`. Once enabled, you can tap twice with 3 fingers to toggle exposé.

Exposé can also manually be activated by calling `toggleExpose()` on your `PanelManager`.

## Customization
You can customize the blur effect of PanelKit's exposé by setting the `exposeOverlayBlurEffect` property on your `PanelManager`.