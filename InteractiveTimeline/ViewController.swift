//  MIT License
//
//  InteractiveTimeline
//  Copyright © 2017 Mikołaj Styś
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class ViewController: UIViewController {
    
    let timeline = TimelineView()
    var constraint: NSLayoutConstraint?
    
    override func loadView() {
        super.loadView()
        setupRootView()
        let scrollView = setupScrollView(into: view)
        scrollView.addSubview(timeline)
        setupTimeline(in: scrollView)
    }
    
    private func setupRootView() {
        view.backgroundColor = .white
    }
    
    private func setupScrollView(into view: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }
    
    private func setupTimeline(in scrollView: UIScrollView) {
        timeline.isUserInteractionEnabled = true
        timeline.backgroundColor = .white
        timeline.translatesAutoresizingMaskIntoConstraints = false
        timeline.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        timeline.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        timeline.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        timeline.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        timeline.prepare(scrollView, updateTime: true)
    }
}
