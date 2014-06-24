//
//  Engine.swift
//  Swift sim engine
//
//  Created by Lee Barney on 6/12/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

import Foundation

class TraditionalEngine{
    
    var time:Int
    var futures:Array<Event>
    var presents:Array<Event>
    
    init(startTime:Int){
        time = startTime
        futures = Array<Event>()
        presents = Array<Event>()
    }
    
    func addEvent(an:Event){
        an.triggerTime > time ? insertFuture(an) : insertPresent(an)
    }
    
    func insertPresent(an:Event){
        _insertEvent(an, isFuture: false)
    }
    
    func insertFuture(an:Event){
        _insertEvent(an, isFuture: true)
    }
    
    func _insertEvent(an:Event, isFuture:Bool){
        var list = isFuture ? futures : presents
        if list.count == 0 {
            isFuture ? futures.append(an) : presents.append(an)
            return
        }
        let first = list[0]
        let end = list.endIndex
        //Arrays are zero based but endIndex is not zero based.
        let last = list[list.endIndex - 1]
        if an.triggerTime <= first.triggerTime {
            list.insert(an, atIndex: 0)
            isFuture ? futures.insert(an, atIndex: 0) : presents.insert(an, atIndex: 0)
        }
        else if an.triggerTime >= last.triggerTime {
            isFuture ? futures.append(an) : presents.append(an)
            
        }
        else {
            var minIndex = 0
            var maxIndex = list.count - 1
            
            while maxIndex >= minIndex {
                var midIndex = (maxIndex + minIndex) / 2
                if list[midIndex].triggerTime > an.triggerTime
                    && list[midIndex - 1].triggerTime <= an.triggerTime {
                        isFuture ? futures.insert(an, atIndex: midIndex) : presents.insert(an, atIndex: midIndex)
                        return
                }
                else if list[midIndex].triggerTime < an.triggerTime
                    && list[midIndex + 1].triggerTime >= an.triggerTime {
                        isFuture ? futures.insert(an, atIndex: midIndex + 1) : presents.insert(an, atIndex: midIndex + 1)
                        return;
                }
                else if list[midIndex].triggerTime < an.triggerTime {
                    minIndex = midIndex
                }
                else {
                    maxIndex = midIndex
                }
            }
        }
    }
    
    func go(){
        while(self.futures.count > 0 || self.presents.count > 0){
            self.doAnyPresents()
            self.doNextGroup()
        }
    }
    
    func doAnyPresents(){
        while presents.count > 0 {
            presents.removeAtIndex(0).action()
        }
    }
    
    func doNextGroup(){
        if futures.count > 0{
            let nextPresent = futures.removeAtIndex(0)
            self.time = nextPresent.triggerTime
            nextPresent.action()
            while futures.count > 0 && futures[0].triggerTime == nextPresent.triggerTime{
                futures.removeAtIndex(0).action()
            }
        }
    }
    
}