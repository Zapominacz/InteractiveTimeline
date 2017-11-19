//
//  TimelineView.swift
//  InteractiveTimeline
//
//  Created by Mikołaj Styś on 19.11.2017.
//  Copyright © 2017 Mikołaj Styś. All rights reserved.
//

import UIKit

class TimelineView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTimeAxis(rect)
    }
    
    private func drawTimeAxis(_ rect: CGRect) {
        let distance: CGFloat = 50.0
        let height: CGFloat = 25.0
        let thickness: CGFloat = 1.5
        let marigin: CGFloat = 10.0
        let color = UIColor.gray
        
        var startPoint = CGPoint(x: rect.maxX - marigin, y: rect.maxY - marigin)
        repeat {
            let destinationPoint = CGPoint(x: startPoint.x, y: startPoint.y - height)
            let path = UIBezierPath()
            path.lineWidth = thickness
            path.move(to: startPoint)
            path.addLine(to: destinationPoint)
            startPoint.x -= distance
            color.set()
            path.stroke()
        } while(startPoint.x >= 0)
//
//        let aPath = UIBezierPath()
//        aPath.lineWidth = 10
//        aPath.lineJoinStyle = .round
//        aPath.move(to: CGPoint(x:rect.minX, y:rect.minY))
//        aPath.addLine(to: CGPoint(x:rect.minX, y:rect.maxY))
//        aPath.addLine(to: CGPoint(x:rect.maxX, y:rect.maxY))
//        aPath.addLine(to: CGPoint(x:rect.maxX, y:rect.minY))
//        //        aPath.addLine(to: CGPoint(x:rect.minX, y:rect.minY))
//        //        aPath.close()
//        UIColor.red.set()
//        aPath.stroke()
    }
    
}
