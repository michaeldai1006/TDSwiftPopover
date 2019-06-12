import Foundation
import UIKit

public struct TDSwiftPopoverConfig {
    let backgroundColor: UIColor
    let size: CGSize
    let items: [TDSwiftPopoverItem]
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

struct TDSwiftPopoverPosition {
    let vertical: TDSwiftPopoverVerticalPosition
    let horizontal: TDSwiftPopoverHorizontalPosition
}

public class TDSwiftPopover {
    // Static values
    static private let defaultPopoverPadding: CGFloat = 10.0
    static private let defaultArrowHeight: CGFloat = 10.0
    
    private let backgroundColor: UIColor
    private let size: CGSize
    private let items: [TDSwiftPopoverItem]
    
    public init(config: TDSwiftPopoverConfig) {
        self.backgroundColor = config.backgroundColor
        self.size = config.size
        self.items = config.items
    }
    
    public func present(onView view: UIView, atPoint point: CGPoint) {
        // Popover frame
        let popoverFrame = getPopoverFrame(baseView: view, presentingPoint: point)
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
            x = TDSwiftPopover.defaultPopoverPadding + self.size.width
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
