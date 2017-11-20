//
//  TimelineView.swift
//  InteractiveTimeline
//
//  Created by Mikołaj Styś on 19.11.2017.
//  Copyright © 2017 Mikołaj Styś. All rights reserved.
//

import UIKit

class TimelineView: UIView {
    
    enum Constants {
        static let timelineHeight: CGFloat = 200
        static let maximumTimelineWidth: CGFloat = 6000
        static let minScale = UIScreen.main.bounds.width / 6000.0
        static let maxScale: CGFloat = 1.0
    }
    
    var widthConstraint: NSLayoutConstraint!
    var scale: CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTimeAxis(rect)
    }
    
    func prepare() {
        heightAnchor.constraint(equalToConstant: Constants.timelineHeight).isActive = true
        widthConstraint = widthAnchor.constraint(equalToConstant: Constants.maximumTimelineWidth)
        widthConstraint?.isActive = true
        addPinchGestureRecognizer()
    }
    
    private func addPinchGestureRecognizer() {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onTimelinePinched))
        addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func onTimelinePinched(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.scale = scale
        case .ended:
            self.scale = sender.scale
        default:
            let scale = max(Constants.minScale, min(Constants.maxScale, sender.scale))
            widthConstraint?.constant = Constants.maximumTimelineWidth * scale
            setNeedsDisplay()
        }
    }
    
    private func getFiveMinutesDistance(_ availableWidth: CGFloat) -> CGFloat {
        return availableWidth / 24.0 / 12.0
    }
    
    private func drawTimeAxis(_ rect: CGRect) {
        let fiveMinutesDistance: CGFloat = getFiveMinutesDistance(rect.width)
        let stepsForHour = 12
        
        let height: CGFloat = 25.0
        let thickness: CGFloat = 1.5
        let marigin: CGFloat = 10.0
        let color = UIColor.gray
        let hourColor = UIColor.black
        
        var count = 0
        var startPoint = CGPoint(x: rect.maxX - marigin, y: rect.maxY - marigin)
        repeat {
            count = (count + 1) % stepsForHour
            let isHour = count == 0
            let destinationPoint = CGPoint(x: startPoint.x, y: startPoint.y - (isHour ? height * 1.25 : height))
            let path = UIBezierPath()
            path.lineWidth = thickness
            path.move(to: startPoint)
            path.addLine(to: destinationPoint)
            startPoint.x -= fiveMinutesDistance
            isHour ? hourColor.set() : color.set()
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
