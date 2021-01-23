//
//  ViewController.swift
//  GestureClassifier
//
//  Created by njuios on 2021/1/6.
//

import UIKit
import CoreMotion
import CoreML
let samplesPerSecond = 25.0
let numberOfFeatures = 6
let windowSize = 20
let windowOffset = 5
let numberOfWindows = windowSize / windowOffset
let bufferSize = windowSize + windowOffset * (numberOfWindows - 1)
let sampleSizeAsBytes = numberOfFeatures * MemoryLayout<Double>.stride
let windowOffsetAsBytes = windowOffset * sampleSizeAsBytes
let windowSizeAsBytes = windowSize * sampleSizeAsBytes
class ViewController: UIViewController {

    @IBOutlet weak var geslabel: UILabel!
    @IBOutlet weak var perlabel: UILabel!
    let modelInput: MLMultiArray! =
        ViewController.makeMLMultiArray(numberOfSamples:windowSize)
    let dataBuffer: MLMultiArray! =
    ViewController.makeMLMultiArray(numberOfSamples:bufferSize)
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    var bufferIndex = 0
    var isDataAvailable = false
    var classifier:GestureClassifier!
    var preoutput:GestureClassifierOutput!
    var gestures = [String]()
    var percents = [Double]()
    @IBAction func start(_ sender: UIButton) {
        motionManager.deviceMotionUpdateInterval = 1 / samplesPerSecond
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue, withHandler: self.motionUpdate)
        sender.isEnabled = false
        print("start predict")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
                classifier = try GestureClassifier(configuration: MLModelConfiguration())
            } catch {
                fatalError("Can't initialize classifier!")
            }
    }

    static private func makeMLMultiArray(numberOfSamples: Int) ->
    MLMultiArray? {
    try? MLMultiArray(
    shape: [1, numberOfSamples, numberOfFeatures] as [NSNumber],
    dataType: .double)
    }
    private func addToBuffer(_ dimen1: Int, _ dimen2: Int, _ data: Double){
        dataBuffer[[0, dimen1, dimen2] as [NSNumber]] = NSNumber(value: data)
    }
    private func buffer(motionData: CMDeviceMotion){
        for offset in [0, windowSize]{
            let index = bufferIndex + offset
            if index >= bufferSize{
                continue
            }
            addToBuffer(index, 0, motionData.rotationRate.x)
            addToBuffer(index, 1, motionData.rotationRate.y)
            addToBuffer(index, 2, motionData.rotationRate.z)
            addToBuffer(index, 3, motionData.userAcceleration.x)
            addToBuffer(index, 4, motionData.userAcceleration.y)
            addToBuffer(index, 5, motionData.userAcceleration.z)
        }
    }
    func predict(){
        if isDataAvailable && bufferIndex % windowOffset == 0 && bufferIndex + windowOffset <= windowSize {
            let window = bufferIndex / windowOffset
            memcpy(modelInput.dataPointer,dataBuffer.dataPointer.advanced(by: window * windowOffsetAsBytes),windowSizeAsBytes)
            
            var preinput: GestureClassifierInput! = nil
            if preoutput != nil{
                preinput = GestureClassifierInput(features: modelInput, hiddenIn: preoutput.hiddenOut, cellIn: preoutput.cellOut)
            } else{
                preinput = GestureClassifierInput(features: modelInput)
            }
            do {
                preoutput = try classifier.prediction(input: preinput)
            } catch{
                fatalError("Unable to predict!")
            }
            var res = self.preoutput.activity
            var percent = self.preoutput.activityProbability[res]!
            var finalres = ""
            var finalper = 0.0
            gestures.append(res)
            percents.append(percent)
            if gestures.count > numberOfWindows{
                gestures.removeFirst()
                percents.removeFirst()
            }
            for index in 0..<gestures.count{
                if percents[index] > percent{
                    res = gestures[index]
                    percent = percents[index]
                }
            }
            finalres = res
            finalper = percent
            DispatchQueue.main.async {
                self.geslabel.text = finalres
                self.perlabel.text = String(format: "%.3f%%", finalper * 100)
            }
        }
    }
    func motionUpdate(data motionData: CMDeviceMotion?, error: Error?){
        guard let motionData = motionData else {
            let errorText = error?.localizedDescription ?? "Unknown"
            print("Device motion update error: \(errorText)")
            return
        }
        buffer(motionData:motionData)
        if !isDataAvailable && bufferIndex == windowSize - 1  {
            isDataAvailable = true
        }
        bufferIndex = (bufferIndex + 1) % windowSize
        predict()
//        print(bufferIndex)

    }

}

