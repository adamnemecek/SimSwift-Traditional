//
//  ViewController.swift
//  Swift Sim Engine - traditional
//
//  Created by Lee Barney on 6/24/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let theEngine = TraditionalEngine(startTime:0)
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..50{
            var randNum = Int(arc4random() % 100)
            if randNum % 15 == 0 {
                randNum = -randNum
            }
            let capturedNum = Int(arc4random() % 50)
            theEngine.addEvent(Event(aTriggerTime: randNum, anAction: {
                println("triggered at: \(randNum) with captured: \(capturedNum)")
                }))
        }
        
        theEngine.go()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

