//
//  ViewController.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation
import MetalKit
import ReactiveSwift

class ViewController: UIViewController {

    var source: ImageSource!
    var source2: ImageSource!
    var filter: ImageOperation!
    lazy var target: RenderView! = {
        let view = RenderView()
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    // var debuggers: [Debugger] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let camera = Camera(position: .front)!
        
        camera.orientation <~ UIDevice.current.reactive.orientation.filterMap { value in
            let orientation: AVCaptureVideoOrientation
            
            switch value {
            case .portrait:         orientation = .portrait
            case .landscapeLeft:    orientation = .landscapeRight
            case .landscapeRight:   orientation = .landscapeLeft
            default: return nil
            }
            return orientation
        }
        
        self.source = camera
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            camera.stopCapture()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            camera.startCapture()
        }
        
        self.source2 = Image("wallpaper")
        
        self.filter = BlendFilter(interpolant: -0.5)
        
        (self.filter, at: 0) <-- self.source
        (self.filter, at: 1) <-- self.source2
        
        self.target <-- self.filter
        
        self.view.addSubview(self.target)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.target.frame = self.view.bounds
    }
}

