import UIKit

class ViewController: UIViewController, TDSwiftPopoverDelegate {
    var popover: TDSwiftPopover!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        // Add popover show buttons
        configShowBtn(atPoint: CGPoint(x: 0.0, y: 35.0))
        configShowBtn(atPoint: CGPoint(x: 305.0, y: 35.0))
        configShowBtn(atPoint: CGPoint(x: 0.0, y: 782.0))
        configShowBtn(atPoint: CGPoint(x: 305.0, y: 782.0))
        configShowBtn(atPoint: CGPoint(x: 152.5, y: 391.0))
    }
    
    func didSelect(item: TDSwiftPopoverItem, atIndex index: Int) {
        print("Item selected with title \(item.titleText) with index \(index)")
    }
    
    private func configShowBtn(atPoint point: CGPoint) {
        let showPopoverBtn = UIButton(frame: CGRect(origin: point, size: CGSize(width: 70.0, height: 30.0)))
        showPopoverBtn.setTitle("Show", for: .normal)
        showPopoverBtn.backgroundColor = .darkGray
        showPopoverBtn.addTarget(self, action: #selector(self.showBtnClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(showPopoverBtn)
    }
    
    @objc private func showBtnClicked(sender: UIButton) {
        // Present popover
        popover.present(onView: self.view, atPoint: sender.center)
    }
}
