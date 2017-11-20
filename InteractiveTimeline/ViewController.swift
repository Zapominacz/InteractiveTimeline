//
//  ViewController.swift
//  InteractiveTimeline
//
//  Created by Mikołaj Styś on 16.11.2017.
//  Copyright © 2017 Mikołaj Styś. All rights reserved.
//

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
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
        timeline.prepare()
    }
}
