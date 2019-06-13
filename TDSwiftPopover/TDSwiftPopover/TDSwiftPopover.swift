import Foundation
import UIKit

public struct TDSwiftPopoverConfig {
    let backgroundColor: UIColor
    let size: CGSize
    let items: [TDSwiftPopoverItem]
    let itemTitleColor: UIColor
    let itemTitleFont: UIFont
}

enum TDSwiftPopoverVerticalPosition {
    case UP
    case DOWN
}

enum TDSwiftPopoverHorizontalPosition {
    case LEFT
    case RIGHT
    case MIDDLE
}

enum TDSwiftPopoverHorizontalDirection {
    case LEFT
    case RIGHT
}

enum TDSwiftPopoverAnimationType {
    case show
    case hide
}

struct TDSwiftPopoverPosition {
    let vertical: TDSwiftPopoverVerticalPosition
    let horizontal: TDSwiftPopoverHorizontalPosition
}

public protocol TDSwiftPopoverDelegate: class {
    func didSelect(item: TDSwiftPopoverItem, atIndex index: Int)
}

public class TDSwiftPopover: NSObject {
    // delegate
    weak var delegate: TDSwiftPopoverDelegate?
    
    // Static values
    static private let defaultPopoverPadding: CGFloat = 10.0
    static private let defaultArrowHeight: CGFloat = 10.0
    
    // Popover properties
    let backgroundColor: UIColor
    let size: CGSize
    let items: [TDSwiftPopoverItem]
    let itemTitleColor: UIColor
    let itemTitleFont: UIFont
    
    // Popover references
    var popoverBaseView: UIView!
    var bgView: UIView!
    var scalePointInBaseView: CGPoint!
    
    public init(config: TDSwiftPopoverConfig) {
        self.backgroundColor = config.backgroundColor
        self.size = config.size
        self.items = config.items
        self.itemTitleColor = config.itemTitleColor
        self.itemTitleFont = config.itemTitleFont
    }
    
    public func present(onView view: UIView, atPoint point: CGPoint) {
        // Popover frame
        let popoverFrame = getPopoverFrame(baseView: view, presentingPoint: point)
        
        // BG View
        bgView = UIView(frame: view.frame)
        bgView.backgroundColor = .clear
        let tapToDismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopover(sender:)))
        tapToDismissGesture.delegate = self
        bgView.addGestureRecognizer(tapToDismissGesture)
        
        // Popover base view
        popoverBaseView = UIView(frame: popoverFrame)
        popoverBaseView.backgroundColor = .clear
        
        // Popover arrow
        let verticalPosition = getPopoverVerticalPosition(baseView: view, presentingPoint: point)
        let pointInBaseView = view.convert(point, to: popoverBaseView)
        scalePointInBaseView = pointInBaseView
        if (verticalPosition == .DOWN) {
            TDSwiftShape.drawTriangle(onView: popoverBaseView,
                                      atPoint: CGPoint(x: pointInBaseView.x, y: pointInBaseView.y + 7.0),
                                      width: 21.0,
                                      height: 13.0,
                                      radius: 2.0,
                                      lineWidth: 0.0,
                                      strokeColor: backgroundColor.cgColor,
                                      fillColor: backgroundColor.cgColor,
                                      rotateAngle: 0.0)
        } else if (verticalPosition == .UP) {
            TDSwiftShape.drawTriangle(onView: popoverBaseView,
                                      atPoint: CGPoint(x: pointInBaseView.x, y: pointInBaseView.y - 7.0),
                                      width: 21.0,
                                      height: 13.0,
                                      radius: 2.0,
                                      lineWidth: 0.0,
                                      strokeColor: backgroundColor.cgColor,
                                      fillColor: backgroundColor.cgColor,
                                      rotateAngle: CGFloat(Double.pi))
        }
        
        // Popover view
        let popoverView = UITableView(frame: CGRect(origin: CGPoint.zero, size: popoverFrame.size))
        popoverView.dataSource = self
        popoverView.delegate = self
        popoverView.clipsToBounds = true
        popoverView.layer.cornerRadius = 5.0
        popoverView.backgroundColor = backgroundColor
        popoverView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        popoverView.tableFooterView = UIView()
        
        // Stack views
        view.addSubview(bgView)
        bgView.addSubview(popoverBaseView)
        popoverBaseView.addSubview(popoverView)
        
        // Animate popover
        animatePopover(animationType: .show)
    }
    
    @objc private func dismissPopover(sender: UITapGestureRecognizer) {
        animatePopover(animationType: .hide)
    }
    
    func animatePopover(animationType type: TDSwiftPopoverAnimationType) {
        // Transforms
        var fromTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        var toTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        var animationDamping: CGFloat = 0.75
        if type == .hide {
            fromTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            toTransform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            animationDamping = 1.0
        }
        
        // Animate popup
        let baseViewFrame = popoverBaseView.frame
        popoverBaseView.layer.anchorPoint = CGPoint(x: scalePointInBaseView.x / popoverBaseView.frame.width, y: scalePointInBaseView.y / popoverBaseView.frame.height)
        popoverBaseView.frame = baseViewFrame
        popoverBaseView.transform = fromTransform
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: animationDamping, initialSpringVelocity: 0.0, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
            self.popoverBaseView.transform = toTransform
        } , completion: { (result) in
            if (type == .hide) {
                self.bgView.removeFromSuperview()
            }
        })
    }
    
    
    // Calculate popover frame
    private func getPopoverFrame(baseView view: UIView, presentingPoint point: CGPoint) -> CGRect {
        // Tempory x y values
        var x: CGFloat = -1.0
        var y: CGFloat = -1.0
        
        // Get popover position
        let position = TDSwiftPopoverPosition(vertical: getPopoverVerticalPosition(baseView: view, presentingPoint: point),
                                              horizontal: getPopoverHorizontalPosition(baseView: view, presentingPoint: point))
        
        // Calculate y value
        if position.vertical == .UP {
            y = point.y - TDSwiftPopover.defaultArrowHeight - self.size.height
        } else if position.vertical == .DOWN {
            y = point.y + TDSwiftPopover.defaultArrowHeight
        }
        
        // Calculate x value
        if (position.horizontal == .MIDDLE) {
            x = point.x - self.size.width / 2
        } else if (position.horizontal == .LEFT) {
            x = view.frame.width - TDSwiftPopover.defaultPopoverPadding - self.size.width
        } else if (position.horizontal == .RIGHT) {
            x = TDSwiftPopover.defaultPopoverPadding
        }
        
        // Popover frame
        return CGRect(origin: CGPoint(x: x, y: y), size: self.size)
    }
    
    // Calculate popover veritical position
    private func getPopoverVerticalPosition(baseView view: UIView, presentingPoint point: CGPoint) -> TDSwiftPopoverVerticalPosition {
        if point.y >= view.frame.height / 2 {
            return .UP
        } else {
            return .DOWN
        }
    }
    
    // Calculate popover horizontal position
    private func getPopoverHorizontalPosition(baseView view: UIView, presentingPoint point: CGPoint) -> TDSwiftPopoverHorizontalPosition {
        if (isEnoughSpace(onDirection: .LEFT, baseView: view, presentingPoint: point) && isEnoughSpace(onDirection: .RIGHT, baseView: view, presentingPoint: point)
            || !isEnoughSpace(onDirection: .LEFT, baseView: view, presentingPoint: point) && !isEnoughSpace(onDirection: .RIGHT, baseView: view, presentingPoint: point)) {
            return .MIDDLE
        }
        
        if (isEnoughSpace(onDirection: .LEFT, baseView: view, presentingPoint: point)) {
            return .LEFT
        } else {
            return .RIGHT
        }
    }
    
    // Wheather enough space on direction
    private func isEnoughSpace(onDirection direction: TDSwiftPopoverHorizontalDirection, baseView view: UIView, presentingPoint point: CGPoint) -> Bool {
        if (direction == .LEFT) {
            return point.x >= TDSwiftPopover.defaultPopoverPadding + self.size.width / 2
        } else {
            return view.frame.width - point.x >= TDSwiftPopover.defaultPopoverPadding + self.size.width / 2
        }
    }
}
