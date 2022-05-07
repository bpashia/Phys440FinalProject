//
//  ContentView.swift
//  Phys440FinalProject
//
//  Created by Broc Pashia on 5/1/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataClass = PlotDataClass(fromLine:true)
    @ObservedObject var rambergOsgoodModel = RambergOsgood()
    @ObservedObject var youngModulus = YoungsModulus()

    enum Material: String, CaseIterable, Identifiable {
        case glass, bone, steel, other
        var id: Self { self }
    }

    @State private var tensileYieldStrength: String = "0.0"
    @State private var percentElongation: String = "0.0"
    @State private var youngsModulus: String = "0.0"
    @State private var ultimatePointStrength: String = "0.0"
    @State private var contentArray:[plotDataType]=[]
    @State private var selected:Int = 1
    
    @State private var filename:String="TensileTestDataSteel.csv"

    @State private var strain:Double=0.0
    @State private var isEditing = false
    @State private var selectedMaterial:Material = .steel

    
    
    var body: some View {
        VStack{

            HStack{
                Button("Young's Modulus Analysis", action: {Task.init{ self.setSelected(selectedVal: 1)}})
                Button("Ramberg-Osgood Analysis", action: {Task.init{ self.setSelected(selectedVal: 2)}})
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                Text(String(selected==1 ? "Young's Modulus Analysis" : "Ramberg-Osgood Analysis"))
                    .font(.system(.largeTitle))
                    .bold()
            if (selected==1){
                       
                            Picker("Material", selection: $selectedMaterial) {
                                Text("Steel-Ductile").tag(Material.steel)
                                Text("Glass-Brittle").tag(Material.glass)
                                Text("Bone-Brittle").tag(Material.bone)
                                Text("Other").tag(Material.other)
                            }.onChange(of: selectedMaterial){newVal in onMaterialChange()}.padding(.bottom, 0)
                            
                HStack{Text("File Name (include .csv):")
                        .padding(.bottom, 0)
          TextField("", text: $filename)
                        .padding(.horizontal)
                        .frame(width: 400)
                        .padding(.top, 0)
                        .padding(.bottom,0).border(.secondary)}
            HStack{
            Text("Tensile Yield Strength(MPa):")
                          .padding(.bottom, 0)
                TextField("", text: $tensileYieldStrength).disabled(true)
                          .padding(.horizontal)
                          .frame(width: 400)
                          .padding(.top, 0)
                          .padding(.bottom,0).border(.secondary)
                Text("Percent Elongation(%):")
                              .padding(.bottom, 0)
                TextField("", text: $percentElongation).disabled(true)
                              .padding(.horizontal)
                              .frame(width: 400)
                              .padding(.top, 0)
                              .padding(.bottom,0).border(.secondary)
            }
            HStack{
            Text("Youngs Modulus(MPa):")
                          .padding(.bottom, 0)
            TextField("", text: $youngsModulus).disabled(true)
                          .padding(.horizontal)
                          .frame(width: 400)
                          .padding(.top, 0)
                          .padding(.bottom,0).border(.secondary)
                Text("Ultimate Point Strength(MPa):")
                              .padding(.bottom, 0)
                TextField("", text: $ultimatePointStrength).disabled(true)
                              .padding(.horizontal)
                              .frame(width: 400)
                              .padding(.top, 0)
                              .padding(.bottom,0).border(.secondary)
            }
            Button("Submit", action: {runYoungsModulusDataOnFileData()})
                if (youngModulus.maxStrain>0.0) {
                    HStack{
                CorePlot(dataForPlot: $contentArray, changingPlotParameters: $dataClass.changingPlotParameters ).frame(width:400, height:400)
                
                
                        VStack{
                    Slider(
                                value: $strain,
                                in: 0...youngModulus.maxStrain,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                    ).frame(width:300, height:100)
                    Text("strain: \(strain)").foregroundColor(isEditing ? .red : .blue)
                        }
                    }
//                    Tensile(strain:strain/100.0, neckingMin:youngModulus.ultimatePointStrain/100.0, neckingMax: youngModulus.maxStrain/100.0).stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)).frame(width:1000.0, height: 250.0)
                    Tensile(strain:strain/100.0, neckingMin:youngModulus.ultimatePointStrain/100.0, neckingMax: youngModulus.maxStrain/100.0).fill(.red).frame(width:1000.0, height: 250.0)
                }
            }
            if (selected==2){
            HStack{
            Text("Tensile Yield Strength(MPa):")
                          .padding(.bottom, 0)
            TextField("", text: $tensileYieldStrength)
                          .padding(.horizontal)
                          .frame(width: 400)
                          .padding(.top, 0)
                          .padding(.bottom,0).border(.secondary)
                Text("Percent Elongation(%):")
                              .padding(.bottom, 0)
                TextField("", text: $percentElongation)
                              .padding(.horizontal)
                              .frame(width: 400)
                              .padding(.top, 0)
                              .padding(.bottom,0).border(.secondary)
            }
            HStack{
            Text("Youngs Modulus(MPa):")
                          .padding(.bottom, 0)
            TextField("", text: $youngsModulus)
                          .padding(.horizontal)
                          .frame(width: 400)
                          .padding(.top, 0)
                          .padding(.bottom,0).border(.secondary)
                Text("Ultimate Point Strength(MPa):")
                              .padding(.bottom, 0)
                TextField("", text: $ultimatePointStrength)
                              .padding(.horizontal)
                              .frame(width: 400)
                              .padding(.top, 0)
                              .padding(.bottom,0).border(.secondary)
            }
            Button("Submit", action: {calculateStressStrainCurve()})
            

            

        }
        if (rambergOsgoodModel.maxStrain>0.0) {
            HStack{
        CorePlot(dataForPlot: $contentArray, changingPlotParameters: $dataClass.changingPlotParameters ).frame(width:400, height:400)
        
        
                VStack{
            Slider(
                        value: $strain,
                        in: 0...rambergOsgoodModel.maxStrain,
                        onEditingChanged: { editing in
                            isEditing = editing
                        }
            ).frame(width:300, height:100)
            Text("strain: \(strain)").foregroundColor(isEditing ? .red : .blue)
                }
            }
            Tensile(strain:strain, neckingMin:rambergOsgoodModel.maxStrain, neckingMax: rambergOsgoodModel.maxStrain).fill(.red).frame(width:1000.0, height: 250.0)
        }
        }

    }

    func onMaterialChange(){
        switch (selectedMaterial){
        case Material.steel:
            filename = "TensileTestDataSteel.csv"
        case Material.bone:
            filename = "TensileTestDataCompactBone.csv"
        case Material.glass:
            filename = "TensileTestDataGlass.csv"
        default:
            filename = ""
        }
    }

    func setSelected(selectedVal: Int) {
        if selectedVal==2 {tensileYieldStrength = "137.9"
          percentElongation = "10.0"
            youngsModulus = "82740.0"
           ultimatePointStrength = "275.79"
            selectedMaterial = Material.steel
            
        }else{
    
        selectedMaterial = Material.steel

        tensileYieldStrength = "0.0"
          percentElongation = "0.0"
            youngsModulus = "0.0"
           ultimatePointStrength = "0.0"
        filename = "TensileTestDataSteel.csv"
        }
        rambergOsgoodModel.resetValues()
        youngModulus.resetValues()
        contentArray = []
            selected = selectedVal
    }
    
    func calculateStressStrainCurve(){
        let ultimatePoint = Double(ultimatePointStrength) ?? 0.0
        
        print("MAX STRAIN")
        print(rambergOsgoodModel.maxStrain + 0.25 * rambergOsgoodModel.maxStrain)
       
        dataClass.changingPlotParameters.yMax = (ultimatePoint + ultimatePoint * 0.25)
        dataClass.changingPlotParameters.yMin = -0.25*ultimatePoint

        dataClass.changingPlotParameters.lineColor = .green()
        dataClass.changingPlotParameters.title = String(format:"Stress vs. Strain")
        
        rambergOsgoodModel.EYoungsModulus = Double(youngsModulus) ?? 0.0
        rambergOsgoodModel.ultimatePointStrength = Double(ultimatePointStrength) ?? 0.0
        rambergOsgoodModel.percentElongationOfMaterial = Double(percentElongation) ?? 0.0
        rambergOsgoodModel.tensileYieldStrength = Double(tensileYieldStrength) ?? 0.0
        
        contentArray = rambergOsgoodModel.calculateStressStrainCurve()
        dataClass.changingPlotParameters.xMax = rambergOsgoodModel.maxStrain*100 + 0.25 * rambergOsgoodModel.maxStrain*100
        dataClass.changingPlotParameters.xMin = -0.25 * rambergOsgoodModel.maxStrain * 100

        print(contentArray)
        print((ultimatePoint + ultimatePoint * 0.1)/1000.0)

}
    func runYoungsModulusDataOnFileData(){
        let fileData =  getFileData()
        let sorted = fileData.sorted(by: {$0[.X]! < $1[.X]!})

            youngModulus.youngsModulusAnalysis(contentArray:  sorted)

            dataClass.changingPlotParameters.xMax = (youngModulus.percentElongationOfMaterial + youngModulus.percentElongationOfMaterial * 0.25)
            dataClass.changingPlotParameters.xMin = -1.0 * youngModulus.percentElongationOfMaterial * 0.25
           
            dataClass.changingPlotParameters.yMax = (youngModulus.ultimatePointStrength + youngModulus.ultimatePointStrength * 0.25)
            dataClass.changingPlotParameters.yMin = -youngModulus.ultimatePointStrength * 0.25
            print(youngModulus.ultimatePointStrength)
            dataClass.changingPlotParameters.lineColor = .green()
            dataClass.changingPlotParameters.title = String(format:"Stress vs. Strain")
            
        contentArray = fileData
        tensileYieldStrength = String(youngModulus.tensileYieldStrength)
        percentElongation = String(youngModulus.percentElongationOfMaterial)
        youngsModulus = String(youngModulus.EYoungsModulus)
        ultimatePointStrength = String(youngModulus.ultimatePointStrength)
            
        
        
        
    }
    func getFileData()->[plotDataType]{
        do{
        return try youngModulus.readFile(filePath: filename)
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
