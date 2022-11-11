import UIKit

final class TriangleView: UIView {

    var color = UIColor.gray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY/2)))
        context.closePath()
        
        context.setFillColor(red: 0.16, green: 0.15, blue: 0.17, alpha: 1)
        context.fillPath()
    }

}
