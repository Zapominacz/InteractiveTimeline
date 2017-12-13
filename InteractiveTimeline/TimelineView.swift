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
        drawFreeTime(rect)
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
    
    let timeBoxYPosition: CGFloat = 60.0
    
    private func drawTimeAxis(_ rect: CGRect) {
        let fiveMinutesDistance: CGFloat = getFiveMinutesDistance(rect.width)
        let stepsForHour = 12
        
        let height: CGFloat = 10.0
        let thickness: CGFloat = 1.5
        let hourHeight: CGFloat = height * 1.5
        let marigin: CGFloat = 0.0
        let color = UIColor.gray
        let hourColor = UIColor.black
        
        
        var count = 0
        var startPoint = CGPoint(x: rect.maxX - marigin, y: timeBoxYPosition - marigin)
        repeat {
            count = (count + 1) % stepsForHour
            let isHour = count == 0
            let destinationPoint = CGPoint(x: startPoint.x, y: startPoint.y - (isHour ? hourHeight : height))
            let path = UIBezierPath()
            path.lineWidth = thickness
            path.move(to: startPoint)
            path.addLine(to: destinationPoint)
            startPoint.x -= fiveMinutesDistance
            isHour ? hourColor.set() : color.set()
            path.stroke()
        } while startPoint.x >= 0
        addLabels(fiveMinutesDistance * CGFloat(stepsForHour), timeBoxYPosition - hourHeight, rect.maxX)
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
    
    private func addLabels(_ dist: CGFloat, _ height: CGFloat, _ allWidth: CGFloat) {
        let w: CGFloat  = 30
        let h: CGFloat  = 12
        let size: CGFloat = 10
        let sampleLabel: NSString = "11:11"
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .light)]
        var rect = CGRect(x: allWidth - 3 + dist / 12.0, y: height - h, width: w, height: h)
        var count = 20
        repeat {
            rect = rect.offsetBy(dx: -dist, dy: 0)
            sampleLabel.draw(in: rect, withAttributes: attrs)
            count -= 1
        } while rect.minX > 0
    }
    
    private func drawFreeTime(_ rect: CGRect) {
        let height: CGFloat = 100.0
        let marigin: CGFloat = timeBoxYPosition
        let color = UIColor(white: 0.9, alpha: 1.0)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0 + marigin))
        path.addLine(to: CGPoint(x: 0, y: height + marigin))
        path.addLine(to: CGPoint(x: rect.maxX, y: height + marigin))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0 + marigin))
        path.close()
        color.setFill()
        path.fill()
    }
    
}
