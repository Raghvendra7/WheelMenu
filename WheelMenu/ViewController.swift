//
//  ViewController.swift
//  WheelMenu
//
//  Created by RMC LTD on 22/02/16.
//  Copyright © 2016 RMC. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,ArcMenuDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        let wheel = ArcMenu(frame: CGRectMake(0, 0, 200, 200), del: self, buttonNumber: 6)
        
        
        wheel.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 50);
        self.view.addSubview(wheel)
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    func menuAction(sender: UIButton) {
        print(sender.tag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

