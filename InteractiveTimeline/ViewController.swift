//
//  ViewController.swift
//  InteractiveTimeline
//
//  Created by Mikołaj Styś on 16.11.2017.
//  Copyright © 2017 Mikołaj Styś. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let timeline = UIView()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(timeline)
        timeline.translatesAutoresizingMaskIntoConstraints = false
        timeline.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        timeline.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timeline.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        timeline.heightAnchor.constraint(equalToConstant: 200).isActive = true
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

