import UIKit

final class TriangleView: UIView {

    var color = UIColor(named: "backgroundLight") {
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
        context.setFillColor(color?.cgColor ?? CGColor(gray: 1, alpha: 1))
        context.fillPath()
    }

}
