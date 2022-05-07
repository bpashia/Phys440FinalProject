//
//  TensileTestGraphic.swift
//  Phys440FinalProject
//
//  Created by Broc Pashia on 5/1/22.
//

import Foundation
import SwiftUI

//Tensile
// Creates a graphic to depict a virtual tensile test using CoreGraphics library
// Struct Variables:
//      strain: current strain of slider
//      neckingMin: the strain value of the stress strain curve where necking begins to take place
//      neckingMax: the strain value of the stress strain curve where necking ends


struct Tensile:Shape {
    var strain:Double
    var neckingMin: Double
    var neckingMax: Double
    
    func path(in rect:CGRect) -> Path {
        print("Tensile " + String(neckingMin) + " " + String(neckingMax))
        let width = rect.width - rect.width * 0.04
        let startingTensileWidth:CGFloat = (rect.height)/4
        let startingTensileLength:CGFloat = (width-rect.height)/(neckingMax+1.0)
        let maxTensileLength:CGFloat = (width-rect.height)
        
       
        let maxNeckingLength = (neckingMax-neckingMin)/neckingMax * maxTensileLength
        let totalTensileArea = startingTensileWidth * startingTensileLength
        let currentTensileLength = strain > neckingMin ? startingTensileLength + startingTensileLength * neckingMin : strain * startingTensileLength + startingTensileLength
        let currentTensileWidth = strain > neckingMin ? totalTensileArea/currentTensileLength : totalTensileArea/currentTensileLength
        
        let neckingLength = strain>neckingMin ? (strain-neckingMin) * startingTensileLength : 0.0
        let neckingWidth = strain > neckingMin ? currentTensileWidth * 0.5 + 0.5 * currentTensileWidth * (neckingMax - strain)/(neckingMax - neckingMin): currentTensileWidth
        let neckingControlPointFactor =  currentTensileWidth * 0.5 - (neckingWidth - currentTensileWidth * 0.5)
        
        let tempXStart =  (width - rect.height - currentTensileLength - neckingLength) / 2.0 + rect.width * 0.02
        let startingXPosition = strain == neckingMax ? tempXStart - rect.width * 0.02 : tempXStart
        let startingYPosition = startingTensileWidth
        
    
        
        var path = Path()
        path.move(to: CGPoint(x:startingXPosition, y: startingYPosition))
        path.addLine(to:CGPoint(x:startingXPosition + startingTensileWidth*2.0, y:startingYPosition))
        path.addLine(to:CGPoint(x:startingXPosition + startingTensileWidth*2.0, y:3*startingTensileWidth))
        path.addLine(to:CGPoint(x:startingXPosition, y:3*startingTensileWidth))
        path.addLine(to:CGPoint(x:startingXPosition, y: startingYPosition))
        path.move(to: CGPoint(x:startingXPosition + startingTensileWidth*2.0, y: (rect.height-currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0, y: (rect.height-currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0, y: (rect.height+currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:startingXPosition+startingTensileWidth*2.0, y: (rect.height+currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:startingXPosition + startingTensileWidth*2.0, y: (rect.height-currentTensileWidth)/2.0 ))
        path.move(to: CGPoint(x:rect.width - startingXPosition, y: rect.height - startingYPosition))
        path.addLine(to:CGPoint(x:rect.width - (startingXPosition + startingTensileWidth*2.0), y:rect.height - startingYPosition))
        path.addLine(to:CGPoint(x:rect.width - (startingXPosition + startingTensileWidth*2.0), y:rect.height - (3*startingTensileWidth)))
        path.addLine(to:CGPoint(x:rect.width - startingXPosition, y:rect.height - (3*startingTensileWidth)))
        path.addLine(to:CGPoint(x:rect.width - startingXPosition, y: rect.height - startingYPosition))
        path.move(to: CGPoint(x:rect.width - (startingXPosition + startingTensileWidth*2.0), y: rect.height - (rect.height-currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0), y: rect.height - (rect.height-currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0), y: rect.height - (rect.height+currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0), y: rect.height - (rect.height+currentTensileWidth)/2.0 ))
        path.addLine(to:CGPoint(x:rect.width - (startingXPosition + startingTensileWidth*2.0), y: rect.height - (rect.height-currentTensileWidth)/2.0 ))
        if (strain > neckingMin) {
            path.move(to:CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0, y: (rect.height-currentTensileWidth)/2.0 ))
            path.addCurve(to: CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0, y: (rect.height-currentTensileWidth)/2.0 + (currentTensileWidth - neckingWidth) / 2.0 ),
                          control1:CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0, y: (rect.height-currentTensileWidth)/2.0 + 0.3 * neckingControlPointFactor), control2: CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0 , y: (rect.height-currentTensileWidth)/2.0 + 0.3 * neckingControlPointFactor ))
                        path.addLine(to:CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0, y: (rect.height-currentTensileWidth)/2.0 + (currentTensileWidth - neckingWidth) / 2.0 + neckingWidth))
            path.addCurve(to: CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0, y: (rect.height+currentTensileWidth)/2.0 ),
                          control1:CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0, y: (rect.height+currentTensileWidth)/2.0 - 0.3 * neckingControlPointFactor), control2: CGPoint(x:startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0, y: (rect.height+currentTensileWidth)/2.0 - 0.3 * neckingControlPointFactor ))
            
            path.move(to:CGPoint(x:rect.width-(startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0), y: (rect.height-currentTensileWidth)/2.0 ))
            path.addCurve(to: CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0), y: (rect.height-currentTensileWidth)/2.0 + (currentTensileWidth - neckingWidth) / 2.0 ),
                          control1:CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0), y: (rect.height-currentTensileWidth)/2.0 + 0.3 * neckingControlPointFactor), control2: CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0) , y: (rect.height-currentTensileWidth)/2.0 + 0.3 * neckingControlPointFactor))
                        path.addLine(to:CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0), y: (rect.height-currentTensileWidth)/2.0 + (currentTensileWidth - neckingWidth) / 2.0 + neckingWidth ))
            path.addCurve(to: CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0), y: (rect.height+currentTensileWidth)/2.0 ),
                          control1:CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0), y: (rect.height+currentTensileWidth)/2.0 - 0.3 * neckingControlPointFactor), control2: CGPoint(x:rect.width - (startingXPosition+startingTensileWidth*2.0+currentTensileLength/2.0 + neckingLength/2.0), y: (rect.height+currentTensileWidth)/2.0 - 0.3 * neckingControlPointFactor))
            
        }
        
        return path
        
}
}
