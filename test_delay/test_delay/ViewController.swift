//
//  ViewController.swift
//  test_delay
//
//  Created by 陈帅 on 2018/12/13.
//  Copyright © 2018 chenshuai. All rights reserved.
//

import UIKit

typealias Task = (_ cancel : Bool) -> Void

class ViewController: UIViewController {
    var task1 : Task? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func onCreateButtonClicked(_ sender: Any) {
        task1 = delay(10) {
            print("10秒后执行")
        }
    }
    
    @IBAction func onStopButtonClicked(_ sender: Any) {
        cancel(task1)
    }
    
    
    func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (()->Void)? = task
        var result: Task?
        
        let delayedClosure : Task = { cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        
        return result
    }
    
    func cancel(_ task: Task?) {
        task?(true)
    }
}

