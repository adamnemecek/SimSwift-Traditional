/*
Copyright (c) 2014 Lee Barney
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


*/

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