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
        static let empty = #colorLiteral(red: 0.9198423028, green: 0.9198423028, blue: 0.9198423028, alpha: 1)
        static let minorDivider = #colorLiteral(red: 0.7504680753, green: 0.7504680753, blue: 0.7504680753, alpha: 1)
        static let majorDivider = #colorLiteral(red: 0.2555047274, green: 0.2555047274, blue: 0.2555047274, alpha: 1)
        static let axisFont = #colorLiteral(red: 0.2596580386, green: 0.2596580386, blue: 0.2596580386, alpha: 1)
        static let plotFont = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    enum Constants {
        static let timelineMarigin: CGFloat = 20.0
        static let axisHeight: CGFloat = 30.0
        static let maxTimelineWidth: CGFloat = 6000
        static let minScale = UIScreen.main.bounds.width / 6000.0
        static let axisLenghtSeconds: TimeInterval = 24.0 * 60 * 60
        static let axisFutureOffset: TimeInterval = 60.0 * 60
        static let maxScale: CGFloat = 1.0
        static let viewHeight: CGFloat = 120.0
        static let axisFont = UIFont.systemFont(ofSize: 10, weight: .light)
        static let plotFont = UIFont.systemFont(ofSize: 12, weight: .light)
        static let axisLabelsMarigin: CGFloat = 5.0
        static let microDividerMultiplier: CGFloat = 0.5
        static let dividerThickness: CGFloat = 1.2
        static let minMicroDistance: CGFloat = 10.0
        static let minLabelDistance: CGFloat = 90.0
    }
    
    private typealias TimelineAreas = (axisArea: CGRect, plotArea: CGRect)
    
    private weak var scrollView: UIScrollView?
    
    var widthConstraint: NSLayoutConstraint!
    var scale: CGFloat = 1
    
    override func draw(_ viewRect: CGRect) {
        super.draw(viewRect)
        let areas = computeAreas(viewRect)
        drawFreeTime(areas.plotArea)
        drawTimeAxis(areas.axisArea)
//        drawLoggedTime(viewRect)
    }
    
    private func computeAreas(_ viewRect: CGRect) -> TimelineAreas {
        let mariginFreeArea = viewRect.insetBy(dx: 0, dy: Constants.timelineMarigin)
        let dividedAreas = mariginFreeArea.divided(atDistance: Constants.axisHeight, from: CGRectEdge.minYEdge)
        return (dividedAreas.slice, dividedAreas.remainder)
    }
    
    private func twoPlacePrecision(_ value: Int) -> String {
        return String(format: "%02d", value)
    }

    private func mapToPosition(timelineView: CGRect, time: Date, currentTime: Date = Date()) -> CGFloat {
        let secondWidth = timelineView.width / CGFloat(Constants.axisLenghtSeconds)
        let minDate = currentTime.addingTimeInterval(Constants.axisFutureOffset - Constants.axisLenghtSeconds)
        let timeOffset = time.timeIntervalSince(minDate)
        return timelineView.minX + CGFloat(timeOffset) * secondWidth
    }

    private func drawTimeAxis(_ axisArea: CGRect) {
        let labelAxisArea = axisArea.divided(atDistance: Constants.axisFont.lineHeight + Constants.axisLabelsMarigin,
                                             from: CGRectEdge.minYEdge)
        drawAxisLabels(labelAxisArea.slice)
        let majorDividerRect = labelAxisArea.remainder
        let minorDividerRect = majorDividerRect.divided(atDistance: Constants.microDividerMultiplier * majorDividerRect.height,
                                                        from: CGRectEdge.maxYEdge).slice
        drawDividers(minorDividerRect, color: Colors.minorDivider, interval: 5 * 60)
        drawDividers(majorDividerRect, color: Colors.majorDivider, interval: 60 * 60)
    }
    
    private func drawDividers(_ area: CGRect, color: UIColor, interval: TimeInterval, currentTime: Date = Date()) {
        let maxTime = Date(timeIntervalSinceNow: Constants.axisFutureOffset)
        var cursorTime = maxTime.truncateTo(minutes: Int(interval / 60.0))
        var computedPosition: CGFloat = 0.0
        repeat {
            computedPosition = mapToPosition(timelineView: area, time: cursorTime)
            cursorTime = cursorTime.addingTimeInterval(-interval)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: computedPosition, y: area.maxY))
            path.addLine(to: CGPoint(x: computedPosition, y: area.minY))
            color.setStroke()
            path.lineWidth = Constants.dividerThickness
            path.stroke()
        } while computedPosition > 0
    }
    
//    let currentTime = Date()
//    print(currentTime)
//    var calendar = Calendar.current
//    let maxTime = Date(timeIntervalSinceNow: 60.0 * 60.0)
//    print(maxTime)
//    var cursorTime = maxTime
//    var components = calendar.dateComponents([.hour, .minute, .second], from: cursorTime)
//    print(components)
//    print(cursorTime)
//    let truncatedMinutes = (components.minute! / 5) * 5
//    cursorTime = calendar.date(bySettingHour: components.hour!, minute: truncatedMinutes, second: 0, of: cursorTime)!
//    print(cursorTime)
//    let timelineWidth = 6000.0
//    // should show 24hours - 23 backwards and one onwards
//    let oneSecondWidth = timelineWidth / 24.0 / 60.0 / 60.0
//
//    var computedDistance = 0.0
//    repeat {
//    let distance = maxTime.timeIntervalSince1970 - cursorTime.timeIntervalSince1970
//    computedDistance = distance * oneSecondWidth
//    let c = calendar.dateComponents([.hour, .minute], from: cursorTime)
//    print("\(c.hour!):\(String(format: "%02d", c.minute!)) - \(timelineWidth - computedDistance) \(calendar.component(.minute, from: cursorTime) == 0)")
//    cursorTime = cursorTime.addingTimeInterval(-60.0 * 5)
//    } while computedDistance < 3000.0
    
    private func drawAxisLabels(_ axisLabelRect: CGRect, currentTime: Date = Date()) {
//        let rect = axisLabelRect.insetBy(dx: 0, dy: Constants.axisLabelsMarigin)
//        let labelWidth: CGFloat = 30
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = .center
//        let attrs: [NSAttributedStringKey: Any] = [.font: Constants.axisFont,
//                                                   .paragraphStyle: paragraph,
//                                                   .foregroundColor: Colors.axisFont]
//        let interval = 60.0 * 60.0
//        let maxTime = Date(timeIntervalSinceNow: Constants.axisFutureOffset)
//        var cursorTime = maxTime.truncateTo(minutes: Int(interval / 60))
//        var computedPosition: CGFloat = 0
//        repeat {
//            computedPosition = mapToPosition(timelineView: rect, time: cursorTime)
//            cursorTime = cursorTime.addingTimeInterval(-interval)
//            "\(hour):00".draw(in: rect, withAttributes: attrs)
//        } while computedPosition.minX > 0
//
//        var rect = CGRect(x: allWidth - w/2 + dist / 12.0, y: height - h, width: w, height: h)
//        let jumpHour = dist > w ? 1 : 3
//        let usedDistance = CGFloat(jumpHour) * dist
//        repeat {
//            rect = rect.offsetBy(dx: -usedDistance, dy: 0)
//            hour -= jumpHour
//
//        } while rect.minX > 0
    }

    func prepare(_ scrollView: UIScrollView? = nil) {
        heightAnchor.constraint(equalToConstant: Constants.viewHeight).isActive = true
        widthConstraint = widthAnchor.constraint(equalToConstant: Constants.maxTimelineWidth)
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
            let newWidth = Constants.maxTimelineWidth * scale
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
    
    private func getMinuteDistance(_ availableWidth: CGFloat) -> CGFloat {
        return availableWidth / 24.0 / 60.0
    }
    
//    private func drawLoggedTime(_ rect: CGRect) {
//        let marigin: CGFloat = timeBoxYPosition
//        let color = Colors.indigo
//
//        let min: CGFloat = 100
//        let max: CGFloat = 500
//
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: min, y: 0 + marigin))
//        path.addLine(to: CGPoint(x: min, y: timeBoxHeight + marigin))
//        path.addLine(to: CGPoint(x: max, y: timeBoxHeight + marigin))
//        path.addLine(to: CGPoint(x: max, y: 0 + marigin))
//        path.close()
//        color.setFill()
//        path.fill()
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = .center
//        let size: CGFloat = 12
//        let font = UIFont.systemFont(ofSize: size, weight: .light)
//
//        let h: CGFloat  = font.lineHeight * 2
//        let attrs: [NSAttributedStringKey: Any] = [.font: font,
//                                                   .paragraphStyle: paragraph, .foregroundColor: UIColor.white]
//        let textRect = CGRect(x: min, y: timeBoxYPosition + (timeBoxHeight - h) / 2, width: max - min, height: h)
//        "Wkurzanie się na Trawińskiego\n00:10".draw(in: textRect, withAttributes: attrs)
//    }
    
    private func drawFreeTime(_ plotArea: CGRect) {
        Colors.empty.setFill()
        UIBezierPath(rect: plotArea).fill()
    }
}

fileprivate extension Date {
    
    func truncateTo(minutes: Int) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let truncatedMinutes = (components.minute! / minutes) * minutes
        return calendar.date(bySettingHour: components.hour!, minute: truncatedMinutes, second: 0, of: self)!
    }
    
}
