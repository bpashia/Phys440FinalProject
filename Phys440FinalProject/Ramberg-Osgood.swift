//
//  Ramberg-Osgood.swift
//  Phys440FinalProject
//
//  Created by Broc Pashia on 5/1/22.
//

import Foundation

class RambergOsgood: NSObject, ObservableObject{
    @Published var tensileYieldStrength:Double = 0.0
    @Published var ultimatePointStrength: Double = 0.0
    @Published var EYoungsModulus: Double = 0.0
    @Published var percentElongationOfMaterial: Double = 0.0
    @Published var maxStrain: Double = 0.0
    
    
    // calculatePlasticStrainAtFailure()
    // calculates the strain value at material failure based on the percent elongation of material
    // epsilonF = %Elongation/100.0
    func calculatePlasticStrainAtFailure()->Double{
        return percentElongationOfMaterial/100.0
    }
    
    //calculateStrainHardeningExponent()
    // calculates the Strain Hardening Exponent n of the material using RambergOsgood class variables
    //            log(S   /  S  )
    //                 tu     ty
    //  n  =   ------------------------
    //            log( epsilon   /  0.002)
    //                         f


    
    private func calculateStrainHardeningExponent()->Double{
        let plasticStrainAtFailure = calculatePlasticStrainAtFailure()
        let strainHardeningExponent = log(ultimatePointStrength/tensileYieldStrength)/log(plasticStrainAtFailure/0.002)
        return strainHardeningExponent
    }
    
    //rambergOsgoodCalculationForStrain()
    // calculates the strain of the material using RambergOsgood model
    // Params:
    //    stress: value of stress in MPa
    //    strainHardeningExponent: n as calculated above
    //                                       1
    //                                       -
    //            sigma            sigma     n
    //epsilon  =  -----  +  0.002 (-----)
    //              E               S
    //                                ty
    
    func rambergOsgoodCalculationForStrain(stress:Double, strainHardeningExponent: Double)->Double{
        let strain = stress/EYoungsModulus + 0.002 * pow(stress/tensileYieldStrength, 1.0/strainHardeningExponent)
        print([stress, strainHardeningExponent,stress/EYoungsModulus,0.002 * pow(stress/tensileYieldStrength, 1.0/strainHardeningExponent),stress/tensileYieldStrength,1.0/strainHardeningExponent])
        return strain
    }
    
    // calculateStressStrainCurve()
    // generates a stress strain curve using rambergoOsgood calculations
    
    func calculateStressStrainCurve()->[plotDataType]{
        let strainHardeningExponent = calculateStrainHardeningExponent()
        let plasticStrainAtFailure = calculatePlasticStrainAtFailure()
        let ultimateStrain = plasticStrainAtFailure + ultimatePointStrength/EYoungsModulus
        var resultArray:[plotDataType]=[]
        var strain = 0.0
        var stress = 0.0
        while strain <= ultimateStrain {
            resultArray.append([.X: 100.0*strain, .Y: stress])
            stress+=tensileYieldStrength/100.0
            strain = rambergOsgoodCalculationForStrain(stress: stress, strainHardeningExponent: strainHardeningExponent)
        }
        maxStrain = resultArray.last![.X]!/100.0
        
        return resultArray
        
    }
    func resetValues(){
        tensileYieldStrength = 0.0
        ultimatePointStrength = 0.0
        EYoungsModulus = 0.0
        percentElongationOfMaterial = 0.0
        maxStrain = 0.0
    }
}
