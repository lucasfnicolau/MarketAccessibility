//
//  StrokeView.swift
//  OneDollar
//
//  Created by Bruno Omella Mainieri on 06/09/17.
//  Based on example by Daniele Margutti (02/10/15)
//
// swiftlint:disable identifier_name
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit
import CoreData

typealias StrokeViewEndBlock = (_ points: [StrokePoint]?) -> Void

public class StrokeView: UIView {
    
    var drawPath: UIBezierPath
    var onDidFinishDrawing: StrokeViewEndBlock?
    var activePoints = [StrokePoint]()
    
    override init(frame: CGRect) {
        drawPath = UIBezierPath()
        super.init(frame: frame)
        self.backgroundColor = UIColor.App.actionColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        drawPath = UIBezierPath()
        super.init(coder: aDecoder)
    }
    
    public func loadPath(points: [StrokePoint]) {
        self.drawPath = UIBezierPath()
        if points.count > 0 {
            guard let first = points.first else { return }
            self.drawPath.move(to: first.toPoint())
            for i in 1..<points.count {
                self.drawPath.addLine(to: points[i].toPoint())
            }
            self.setNeedsDisplay()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.drawPath = UIBezierPath()

        activePoints.removeAll()
        
        guard let first = touches.first else { return }
        let point = first.location(in: self)
        self.drawPath.move(to: point)
        activePoints.append(StrokePoint(point: point))
        
        self.setNeedsDisplay()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else { return }
        let point = first.location(in: self)
        self.drawPath.addLine(to: point)
        activePoints.append(StrokePoint(point: point))
        
        self.setNeedsDisplay()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else { return }
        let point = first.location(in: self)
        self.drawPath.move(to: point)
        activePoints.append(StrokePoint(point: point))
        self.setNeedsDisplay()
        
        onDidFinishDrawing?(activePoints)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        guard let touches = touches else { return }
        self.touchesEnded(touches, with: event)
    }
    
    public override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setLineWidth(5.0)
        ctx.setStrokeColor(UIColor.App.white.cgColor)
        ctx.addPath(self.drawPath.cgPath)
        ctx.strokePath()
    }
    
    func resetPoints() {
        self.drawPath = UIBezierPath()
        self.activePoints.removeAll()
        self.drawPath.move(to: CGPoint.zero)
        self.setNeedsDisplay()
    }
}
