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
    
    private func setupScrollView(into view: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return scrollView
    }
    
    private func createTimeline(in scrollView: UIScrollView) {
        timeline.backgroundColor = .white
        timeline.translatesAutoresizingMaskIntoConstraints = false
        timeline.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        timeline.heightAnchor.constraint(equalToConstant: 200).isActive = true
        timeline.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        timeline.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        timeline.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        timeline.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        let scrollView = setupScrollView(into: view)
        scrollView.addSubview(timeline)
        createTimeline(in: scrollView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

