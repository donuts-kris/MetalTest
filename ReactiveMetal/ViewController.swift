//
//  ViewController.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import MetalKit
import ReactiveSwift

class ViewController: UIViewController {

    var source: Camera!
    var filter: ImageOperation!
    var target: RenderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.source = Camera(position: .front)!
        // let filter = LookupFilter(image: "pretty", intensity: 1)
        let filter = HSVFilter()

        self.target = RenderView(frame: self.view.frame)
        
        let rgb = RGBFilter()
        
        self.filter = OperationGroup(operations: rgb, filter)
    
        self.filter <-- self.source
        self.target <-- self.filter
        
        self.view.addSubview(self.target)
        
        Debugger.default.makeSilder(for: filter.hue, range: 0 ... 1)
        Debugger.default.makeSilder(for: filter.saturation, range: 0 ... 1)
        Debugger.default.makeSilder(for: filter.value, range: 0 ... 1)
        
        Debugger.default.makeSilder(for: rgb.red, range: 0 ... 1)
        Debugger.default.makeSilder(for: rgb.green, range: 0 ... 1)
        Debugger.default.makeSilder(for: rgb.blue, range: 0 ... 1)
    }
}

