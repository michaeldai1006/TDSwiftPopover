import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Popover items
        let popoverItems = [
            TDSwiftPopoverItem(iconImage: UIImage(), titleText: "1"),
            TDSwiftPopoverItem(iconImage: UIImage(), titleText: "2"),
            TDSwiftPopoverItem(iconImage: UIImage(), titleText: "3"),
            TDSwiftPopoverItem(iconImage: UIImage(), titleText: "4"),
            TDSwiftPopoverItem(iconImage: UIImage(), titleText: "5")
        ]
        
        // Popover instance
        let popover = TDSwiftPopover.init(config: TDSwiftPopoverConfig(backgroundColor: .red,
                                                                       size: CGSize(width: 195.0, height: 222.0),
                                                                       items: popoverItems))
        
        // Present popover
        popover.present(onView: self.view, atPoint: CGPoint(x: 300.0, y: 100.0))
    }
}
