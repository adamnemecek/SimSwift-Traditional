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

