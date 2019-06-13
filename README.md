# TDSwiftPopover
<p align="center">
  <img src="./README/Images/TDSwiftPopover.gif" width="40%" height="40%" />
</p>

<br/>

To initialize:
```swift
// Popover items
let popoverItems = [
    TDSwiftPopoverItem(iconImage: #imageLiteral(resourceName: "conversation"), titleText: "Some Item 1"),
    TDSwiftPopoverItem(iconImage: #imageLiteral(resourceName: "phone"), titleText: "Some Item 2"),
    TDSwiftPopoverItem(iconImage: #imageLiteral(resourceName: "phone"), titleText: "Some Item 3"),
    TDSwiftPopoverItem(iconImage: #imageLiteral(resourceName: "placeholder"), titleText: "Some Item 4"),
    TDSwiftPopoverItem(iconImage: #imageLiteral(resourceName: "stop"), titleText: "Some Item 5")
]

// Popover instance
popover = TDSwiftPopover.init(config: TDSwiftPopoverConfig(backgroundColor: UIColor(red:0.06, green:0.03, blue:0.42, alpha:1.0),
                                                            size: CGSize(width: 195.0, height: 222.0),
                                                            items: popoverItems,
                                                            itemTitleColor: .white,
                                                            itemTitleFont: UIFont.systemFont(ofSize: 12.0, weight: .medium)))
popover.delegate = self
```

<br/>

To present:
```swift
// Present popover
popover.present(onView: self.view, atPoint: sender.center)
```

<br/>

TDSwiftPopoverDelegate:
```swift
func didSelect(item: TDSwiftPopoverItem, atIndex index: Int) {
    print("Item selected with title \(item.titleText) with index \(index)")
}
```