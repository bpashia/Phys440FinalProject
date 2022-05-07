//
//  YoungsModulus.swift
//  Phys440FinalProject
//
//  Created by Broc Pashia on 5/1/22.
//

import Foundation

enum YMError: Error {
case fileNotFound
}

class YoungsModulus: NSObject, ObservableObject{
    @Published var tensileYieldStrength:Double = 0.0
    @Published var ultimatePointStrength: Double = 0.0
    @Published var ultimatePointStrain: Double = 0.0
    @Published var EYoungsModulus: Double = 0.0
    @Published var percentElongationOfMaterial: Double = 0.0
    @Published var maxStrain: Double = 0.0
    
    
    // readFile(filePath: String)
    // searches for a csv file in the current directory by name and returns the data in a contentArray format for core plot
    // Params:
    //      filePath: name of a file that exists in the current directory
    
    func readFile(filePath:String) throws ->[plotDataType]{
        if (filePath.split(separator:".").count != 2){
            return []
        }
        let fileName = filePath.split(separator:".")[0]

        guard let url = Bundle.main.url(
            forResource: String(fileName),
            withExtension: "csv"
        ) else {
            throw YMError.fileNotFound
        }
        do{
            let data = try String(contentsOf: url)
            let split = data.split(separator: "\n")
            let splitAgain = split.map {String($0).components(separatedBy:", ")}
            let contentArray: [plotDataType] = splitAgain.map {(str)-> plotDataType in [.X: Double(str[0])! * 100,.Y: Double(str[1])!]}
            return contentArray
        }
        catch{
            print(error.localizedDescription)
            return []
        }
        
    }
    
    // youngsModulusAnalysis(contentArray:[plotDataType]
    // Runs an analysis on a content Array of strain/stress values and populates the class variables of the YoungsModulus class
    // Params:
    //      contentArray: an array of plotDataType values containing strain/stress curve data for a material
    
    func youngsModulusAnalysis(contentArray: [plotDataType]){
        let sorted = contentArray.sorted(by: {$0[.X]! < $1[.X]!})
        let slope = (sorted[10][.Y]! - sorted[0][.Y]!)/(sorted[10][.X]! - sorted[0][.X]!)
        EYoungsModulus = slope
    
        let ultimateStrength:plotDataType = sorted.max(by: {$0[.Y]! < $1[.Y]!})!
        ultimatePointStrength = ultimateStrength[.Y]!
        ultimatePointStrain = ultimateStrength[.X]!
        var tensileStrength = 0.0
        func pointTwoPercentOffset(x:Double)->Double{
            return slope * (x+0.002)
        }
        for i in 0...contentArray.count - 2{
            let current = contentArray[i]
            let next = contentArray[i+1]
            tensileStrength = current[.Y]!
            let offsetVal:Double = pointTwoPercentOffset(x: current[.X]!)
            if (offsetVal >= next[.Y]!){
                break
            }
        }
        tensileYieldStrength = tensileStrength
        maxStrain = sorted.last![.X]!
        percentElongationOfMaterial = round((maxStrain * 100.0))/100.0
    }
    
    // resetValues()
    // reset class values for instance of YoungsModulus
    
    func resetValues(){
        tensileYieldStrength = 0.0
        ultimatePointStrength = 0.0
        EYoungsModulus = 0.0
        ultimatePointStrain = 0.0
        percentElongationOfMaterial = 0.0
        maxStrain = 0.0
    }
    
    
}
