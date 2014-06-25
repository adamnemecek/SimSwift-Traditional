/*
Copyright (c) 2012 Lee Barney
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
        an.triggerTime > time ? insertEvent(an, isFuture: true) : insertEvent(an, isFuture: false)
    }
    
    func insertEvent(an:Event, isFuture:Bool){
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