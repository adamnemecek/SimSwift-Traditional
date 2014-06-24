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
        _insertEvent(an, list:presents)
    }
    
    func insertFuture(an:Event){
        _insertEvent(an, list:futures)
    }
    
    func _insertEvent(an:Event, list:Array<Event>){
        if futures.count == 0 {
            futures.append(an)
            return
        }
        let first = futures[0]
        let end = futures.endIndex
        //Arrays are zero based but endIndex is not zero based.
        let last = futures[futures.endIndex - 1]
        if an.triggerTime <= first.triggerTime {
            futures.insert(an, atIndex: 0)
        }
        else if an.triggerTime >= last.triggerTime {
            futures.append(an)
            
        }
        else {
            var minIndex = 0
            var maxIndex = futures.count - 1
            
            while maxIndex >= minIndex {
                var midIndex = (maxIndex + minIndex) / 2
                if futures[midIndex].triggerTime > an.triggerTime
                    && futures[midIndex - 1].triggerTime <= an.triggerTime {
                        futures.insert(an, atIndex: midIndex)
                        return
                }
                else if futures[midIndex].triggerTime < an.triggerTime
                    && futures[midIndex + 1].triggerTime >= an.triggerTime {
                        futures.insert(an, atIndex: midIndex + 1)
                        return;
                }
                else if futures[midIndex].triggerTime < an.triggerTime {
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