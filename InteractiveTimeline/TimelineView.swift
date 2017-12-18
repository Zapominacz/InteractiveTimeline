//
//  TimelineView.swift
//  InteractiveTimeline
//
//  Created by Mikołaj Styś on 19.11.2017.
//  Copyright © 2017 Mikołaj Styś. All rights reserved.
//

import UIKit

struct TimelineBlock {
    var from: Date
    var to: Date?
    var name: String
    var color: UIColor
}

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
        static let currentTimeIndicator = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        static let axisFont = #colorLiteral(red: 0.2596580386, green: 0.2596580386, blue: 0.2596580386, alpha: 1)
        static let plotFont = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    enum Constants {
        static let viewUpdateInterval: TimeInterval = 30.0
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
        static let minLabelDistance: CGFloat = 30.0
        static let minimumBlockWidthForLabel: CGFloat = 30.0
    }
    
    private typealias TimelineAreas = (axisArea: CGRect, plotArea: CGRect)
    
    var data: [TimelineBlock] = [TimelineBlock(from: Date(timeIntervalSinceNow: -60 * 60 * 20.6),
                                               to: Date(timeIntervalSinceNow: -60 * 60 * 20), name: "Lorem ipsum",
                                               color: Colors.green),
                                TimelineBlock(from: Date(timeIntervalSinceNow: -60 * 60 * 19),
                                              to: Date(timeIntervalSinceNow: -60 * 60 * 15), name: "ZPI :/",
                                              color: Colors.indigo)]
    
    private weak var scrollView: UIScrollView?
    
    var widthConstraint: NSLayoutConstraint!
    var scale: CGFloat = 1
    var timer: Timer?
    
    override func draw(_ viewRect: CGRect) {
        super.draw(viewRect)
        let areas = computeAreas(viewRect)
        drawFreeTime(areas.plotArea)
        drawTimeAxis(areas.axisArea)
        drawLoggedTime(areas.plotArea)
        drawCurrentTimeIndicator(areas.plotArea)
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
    
    private func drawCurrentTimeIndicator(_ rect: CGRect, currentDate: Date = Date()) {
        let position = mapToPosition(timelineView: rect, time: currentDate)
        let divider = UIBezierPath()
        divider.move(to: CGPoint(x: position, y: rect.minY))
        divider.addLine(to: CGPoint(x: position, y: rect.maxY))
        Colors.currentTimeIndicator.set()
        divider.lineWidth = Constants.dividerThickness
        divider.stroke()
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: position, y: rect.maxY + 4))
        triangle.addLine(to: CGPoint(x: position - 5, y: rect.maxY))
        triangle.addLine(to: CGPoint(x: position + 5, y: rect.maxY))
        triangle.close()
        triangle.fill()
    }

    private func drawTimeAxis(_ axisArea: CGRect) {
        let labelAxisArea = axisArea.divided(atDistance: Constants.axisFont.lineHeight + Constants.axisLabelsMarigin,
                                             from: CGRectEdge.minYEdge)
        let majorDividerRect = labelAxisArea.remainder
        let minorDividerRect = majorDividerRect.divided(atDistance: Constants.microDividerMultiplier * majorDividerRect.height,
                                                        from: CGRectEdge.maxYEdge).slice
        let mictoDividerInterval: CGFloat = 5 * 60.0
        if axisArea.width / CGFloat(Constants.axisLenghtSeconds) * mictoDividerInterval > Constants.minMicroDistance {
            drawDividers(minorDividerRect, color: Colors.minorDivider, interval: 5 * 60)
        }
        drawDividers(majorDividerRect, color: Colors.majorDivider, interval: 60 * 60)
        drawAxisLabels(labelAxisArea.slice)
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
    
    private func drawAxisLabels(_ axisLabelRect: CGRect, currentTime: Date = Date()) {
        let rect = axisLabelRect.insetBy(dx: 0, dy: Constants.axisLabelsMarigin / 2)
        let calendar = Calendar.current
        let labelWidth: CGFloat = 30
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attrs: [NSAttributedStringKey: Any] = [.font: Constants.axisFont,
                                                   .paragraphStyle: paragraph,
                                                   .foregroundColor: Colors.axisFont]
        let interval = 60.0 * 60.0
        let maxTime = Date(timeIntervalSinceNow: Constants.axisFutureOffset)
        var cursorTime = maxTime.truncateTo(minutes: Int(interval / 60))
        var nextPosition: CGFloat = 0
        var currentPosition: CGFloat = CGFloat.infinity
        repeat {
            nextPosition = mapToPosition(timelineView: rect, time: cursorTime)
            let components = calendar.dateComponents([.hour, .minute], from: cursorTime)
            cursorTime = cursorTime.addingTimeInterval(-interval)
            guard currentPosition - nextPosition >= Constants.minLabelDistance else {
                continue
            }
            currentPosition = nextPosition
            let labelRect = CGRect(x: currentPosition - labelWidth / 2,
                                   y: rect.minY, width: labelWidth, height: rect.height)
            "\(components.hour!):\(twoPlacePrecision(components.minute!))".draw(in: labelRect, withAttributes: attrs)
        } while nextPosition > labelWidth / 2
    }

    func prepare(_ scrollView: UIScrollView? = nil, updateTime: Bool = false) {
        heightAnchor.constraint(equalToConstant: Constants.viewHeight).isActive = true
        widthConstraint = widthAnchor.constraint(equalToConstant: Constants.maxTimelineWidth)
        widthConstraint?.isActive = true
        addPinchGestureRecognizer()
        self.scrollView = scrollView
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let startPosition = self.mapToPosition(timelineView: self.bounds, time: Date()) - UIScreen.main.bounds.width / 2
            scrollView?.contentOffset = CGPoint(x: startPosition, y: scrollView?.contentOffset.y ?? 0)
        }
        if updateTime {
            setupTimer()
        }
    }
    
    private func setupTimer() {
        let timer = Timer(timeInterval: Constants.viewUpdateInterval, repeats: true) { [weak self] _ in
            self?.setNeedsDisplay()
        }
        self.timer = timer
        RunLoop.main.add(timer, forMode: .commonModes)
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
    
    private func drawLoggedTime(_ rect: CGRect) {
        let calendar = Calendar.current
        data.forEach { block in
            let fromPosition = mapToPosition(timelineView: rect, time: block.from)
            let toPosition = mapToPosition(timelineView: rect, time: block.to ?? Date())
            let blockWidth = toPosition - fromPosition
            let blockRect = CGRect(x: fromPosition, y: rect.minY, width: blockWidth, height: rect.height)
            let path = UIBezierPath(rect: blockRect)
            block.color.setFill()
            path.fill()
            
            guard blockWidth > Constants.minimumBlockWidthForLabel else { return }
            let timeInterval = calendar.dateComponents([.hour, .minute], from: block.from, to: block.to ?? Date())
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attrs: [NSAttributedStringKey: Any] = [.font: Constants.plotFont,
                                                       .paragraphStyle: paragraph, .foregroundColor: UIColor.white]
            let labelRect = blockRect.insetBy(dx: 0, dy: (blockRect.height - Constants.plotFont.lineHeight * 2) / 2)
            "\(block.name)\n\(timeInterval.hour!):\(twoPlacePrecision(timeInterval.minute!))"
                .draw(in: labelRect, withAttributes: attrs)
        }
    }
    
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
