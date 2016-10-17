//
//  DrawView.swift
//  TouchTracker
//
//  Created by Christian Perrone on 17/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    //var currentLine: Line?
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor = UIColor.red {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    func strokeLine(line: Line) {
        
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        //Draw finished lines in black
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        
        /*
        if let line = currentLine {
            UIColor.red.setStroke()
            strokeLine(line: line)
        }
        */
        
        currentLineColor.setStroke()
        
        for (_, line) in currentLines {
            strokeLine(line: line)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*
        let touch = touches.first!
        //get the location of the touch
        let location = touch.location(in: self)
        currentLine = Line(begin: location, end: location)
        */
        
        for touch in touches {
            
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location)
            let key = NSValue.init(nonretainedObject: touch)
            
            currentLines[key] = newLine
        }
        
        
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*
        let touch = touches.first!
        let location = touch.location(in: self)
        
        currentLine?.end = location
        */
        
        for touch in touches {
            
            let key = NSValue.init(nonretainedObject: touch)
            
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            
            finishedLines.append(line)
        }
        
        currentLine = nil
        */
        
        for touch in touches {
            
            let key = NSValue.init(nonretainedObject: touch)
            
            if var line = currentLines[key] {
                
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        
        addGestureRecognizer(doubleTapRecognizer)
    }
    
    func doubleTap(gestureRecognizer: UIGestureRecognizer) {
        
        print("Double tap recognized")
        
        currentLines.removeAll(keepingCapacity: false)
        finishedLines.removeAll(keepingCapacity: false)
        setNeedsDisplay()
    }
    
}
