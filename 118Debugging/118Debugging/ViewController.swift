//
//  ViewController.swift
//  118Debugging
//
//  Created by Mirko Braic on 23/12/2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(1, 2, 3, 4, 5, separator: "-", terminator: "")
        
        // assert is never exectued in released app
        assert(1 == 1, "Maths failure!")
        
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
    }
}

