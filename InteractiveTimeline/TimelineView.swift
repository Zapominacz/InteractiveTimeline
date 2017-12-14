//
//  TimelineView.swift
//  InteractiveTimeline
//
//  Created by Mikołaj Styś on 19.11.2017.
//  Copyright © 2017 Mikołaj Styś. All rights reserved.
//

import UIKit

class TimelineView: UIView {
    
    enum Colors {
        static let green = #colorLiteral(red: 0.262745098, green: 0.6274509804, blue: 0.2784313725, alpha: 1)
        static let teal = #colorLiteral(red: 0.1490196078, green: 0.6509803922, blue: 0.6039215686, alpha: 1)
        static let indigo = #colorLiteral(red: 0.3607843137, green: 0.4196078431, blue: 0.7529411765, alpha: 1)
        static let red = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
        static let amber = #colorLiteral(red: 1, green: 0.7921568627, blue: 0.1568627451, alpha: 1)
        static let brown = #colorLiteral(red: 0.5529411765, green: 0.431372549, blue: 0.3882352941, alpha: 1)
    }
    
    enum Constants {
        static let timelineHeight: CGFloat = 200
        static let maximumTimelineWidth: CGFloat = 6000
        static let minScale = UIScreen.main.bounds.width / 6000.0
        static let maxScale: CGFloat = 1.0
    }
    
    weak var scrollView: UIScrollView?
    
    var widthConstraint: NSLayoutConstraint!
    var scale: CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawFreeTime(rect)
        drawTimeAxis(rect)
        drawLoggedTime(rect)
    }
    
    func prepare(_ scrollView: UIScrollView? = nil) {
        heightAnchor.constraint(equalToConstant: Constants.timelineHeight).isActive = true
        widthConstraint = widthAnchor.constraint(equalToConstant: Constants.maximumTimelineWidth)
        widthConstraint?.isActive = true
        addPinchGestureRecognizer()
        self.scrollView = scrollView
    }
    
    private func addPinchGestureRecognizer() {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onTimelinePinched))
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    private func onTimelinePinched(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.scale = max(Constants.minScale, min(Constants.maxScale, scale))
            
        case .ended:
            scale = max(Constants.minScale, min(Constants.maxScale, sender.scale))
        default:
            let scale = max(Constants.minScale, min(Constants.maxScale, sender.scale))
            let newWidth = Constants.maximumTimelineWidth * scale
            let currentScale = newWidth / (widthConstraint?.constant ?? 0)
            widthConstraint?.constant = newWidth
            setNeedsDisplay()
            guard let scrollView = scrollView, sender.numberOfTouches > 1 else { return }
            let touchCenter = (sender.location(ofTouch: 0, in: self).x + sender.location(ofTouch: 1, in: self).x) / 2.0
            let touchDistance = touchCenter - scrollView.contentOffset.x
            var offset = scrollView.contentOffset
            offset.x = touchCenter * currentScale - touchDistance
            scrollView.setContentOffset(offset, animated: false)
        }
    }
    
    private func getFiveMinutesDistance(_ availableWidth: CGFloat) -> CGFloat {
        return availableWidth / 24.0 / 12.0
    }
    
    let timeBoxYPosition: CGFloat = 60.0
    let timeBoxHeight: CGFloat = 100.0
    
    private func drawTimeAxis(_ rect: CGRect) {
        let fiveMinutesDistance: CGFloat = getFiveMinutesDistance(rect.width)
        let stepsForHour = 12
        
        let height: CGFloat = 7
        let thickness: CGFloat = 1.2
        let hourHeight: CGFloat = height * 2
        let marigin: CGFloat = 0.0
        let color = UIColor.gray
        let hourColor = UIColor.black
        let printMinutes = fiveMinutesDistance > 10.0
        
        var count = 0
        var startPoint = CGPoint(x: rect.maxX - marigin, y: timeBoxYPosition - marigin)
        repeat {
            count = (count + 1) % stepsForHour
            let isHour = count == 0
            guard printMinutes || isHour else {
                startPoint.x -= fiveMinutesDistance
                continue
            }
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
        var hour = 23
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .light), .paragraphStyle: paragraph]
        var rect = CGRect(x: allWidth - w/2 + dist / 12.0, y: height - h, width: w, height: h)
        let jumpHour = dist > w ? 1 : 3
        let usedDistance = CGFloat(jumpHour) * dist
        repeat {
            rect = rect.offsetBy(dx: -usedDistance, dy: 0)
            hour -= jumpHour
            "\(hour):00".draw(in: rect, withAttributes: attrs)
        } while rect.minX > 0
    }
    
    private func drawLoggedTime(_ rect: CGRect) {
        let marigin: CGFloat = timeBoxYPosition
        let color = Colors.indigo
        
        let min: CGFloat = 100
        let max: CGFloat = 500
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: min, y: 0 + marigin))
        path.addLine(to: CGPoint(x: min, y: timeBoxHeight + marigin))
        path.addLine(to: CGPoint(x: max, y: timeBoxHeight + marigin))
        path.addLine(to: CGPoint(x: max, y: 0 + marigin))
        path.close()
        color.setFill()
        path.fill()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let size: CGFloat = 12
        let font = UIFont.systemFont(ofSize: size, weight: .light)
        
        let h: CGFloat  = font.lineHeight * 2
        let attrs: [NSAttributedStringKey: Any] = [.font: font,
                                                   .paragraphStyle: paragraph, .foregroundColor: UIColor.white]
        let textRect = CGRect(x: min, y: timeBoxYPosition + (timeBoxHeight - h) / 2, width: max - min, height: h)
        "Wkurzanie się na Trawińskiego\n00:10".draw(in: textRect, withAttributes: attrs)
    }
    
    private func drawFreeTime(_ rect: CGRect) {
        
        let marigin: CGFloat = timeBoxYPosition
        let color = UIColor(white: 0.9, alpha: 1.0)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0 + marigin))
        path.addLine(to: CGPoint(x: 0, y: timeBoxHeight + marigin))
        path.addLine(to: CGPoint(x: rect.maxX, y: timeBoxHeight + marigin))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0 + marigin))
        path.close()
        color.setFill()
        path.fill()
    }
    
}
