import Foundation
import UIKit

public class TDSwiftShape {
    public static func drawCircle(onView view: UIView, atCenter center: CGPoint, redius: CGFloat, lineWidth: CGFloat, fillColor: CGColor, strokeColor: CGColor) {
        let circlePath = UIBezierPath(arcCenter: center, radius: redius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = fillColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        
        view.layer.addSublayer(shapeLayer)
    }
    
    public static func drawDashedLine(onView view: UIView, fromPoint from: CGPoint, toPoint to: CGPoint, lineWidth: CGFloat, dashLength: NSNumber, dashGap: NSNumber, strokeColor: CGColor) {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = [dashLength, dashGap]
        
        let path = CGMutablePath()
        path.addLines(between: [from, to])
        shapeLayer.path = path
        
        view.layer.addSublayer(shapeLayer)
    }
    
    public static func drawTriangle(onView view: UIView, atPoint point: CGPoint, width: CGFloat, height: CGFloat, radius: CGFloat, lineWidth: CGFloat, strokeColor: CGColor, fillColor: CGColor, rotateAngle rotate: CGFloat) {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.position = point
        shapeLayer.lineWidth = lineWidth
        shapeLayer.transform = CATransform3DMakeRotation(rotate, 0.0, 0.0, 1.0)
        
        let point1 = CGPoint(x: -width / 2, y: height / 2)
        let point2 = CGPoint(x: 0, y: -height / 2)
        let point3 = CGPoint(x: width / 2, y: height / 2)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
        path.closeSubpath()
        shapeLayer.path = path
        
        view.layer.addSublayer(shapeLayer)
    }
}
