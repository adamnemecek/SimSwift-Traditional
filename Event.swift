//
//  Event.swift
//  Swift sim engine
//
//  Created by Lee Barney on 6/12/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

import Foundation

class Event{
    let triggerTime:Int
    let action:()->()
    
    init(aTriggerTime:Int, anAction:()->()){
        triggerTime = aTriggerTime
        action = anAction
    }
}
