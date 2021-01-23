//
//  ViewController.swift
//  HealthySnacks
//
//  Created by CuiZihan on 2020/9/26.
//

import UIKit
import CoreMedia
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var imv: UIImageView!
    let labels = ["apple", "banana", "cake", "candy", "carrot", "cookie",
                  "doughnut", "grape", "hot dog", "ice cream", "juice",
                  "muffin", "orange", "pineapple", "popcorn", "pretzel",
                  "salad", "strawberry", "waffle", "watermelon"]
    // for video capturing
/*    var videoCapturer: VideoCapture!
    let semphore = DispatchSemaphore(value: ViewController.maxInflightBuffer)
    var inflightBuffer = 0
    static let maxInflightBuffer = 2*/
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            let classifier = try fooddetector(configuration: MLModelConfiguration())
            
            let model = try VNCoreMLModel(for: classifier.model)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request,error in
                self?.processObservations(for: request, error: error)
            })
            request.imageCropAndScaleOption = .scaleFill
            return request
            
            
        } catch {
            fatalError("Failed to create request")
        }
    }()

    @IBAction func selectPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
 /*   func classify(sampleBuffer: CMSampleBuffer) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            }
            DispatchQueue.main.async {
                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
                do {
                    try handler.perform([self.classificationRequest])
                } catch {
                    print("Failed to perform classification: \(error)")
                }
                self.semphore.signal()
            }
            
        } else {
            print("Create pixel buffer failed")
        }
    }*/
    func classify(image:UIImage){
        if let imadata = image.cgImage{
            DispatchQueue.main.async{
                let handler = VNImageRequestHandler(cgImage:imadata)
                do {
                    try handler.perform([self.classificationRequest])
                } catch {
                    print("Failed to perform classification: \(error)")
                }
            }
        }
        else {
            print("Create cgimage failed")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  //      self.setUpCamera()
    }
    
/*    func setUpCamera() {
        self.videoCapturer = VideoCapture()
        self.videoCapturer.delegate = self
        
        videoCapturer.frameInterval = 1
        videoCapturer.setUp(sessionPreset: .high, completion: {
            success in
            if success {
                if let previewLayer = self.videoCapturer.previewLayer {
                   /* self.videoView.layer.addSublayer(previewLayer)
                    self.videoCapturer.previewLayer?.frame = self.videoView.bounds*/
                    self.videoCapturer.start()
                }
            }
            else {
                print("Video capturer set up failed")
            }
        })
    }*/
    
    


}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        resultLabel.text = "Calculating..."
        guard let ima = info[.originalImage] as? UIImage else {
            return
        }
        classify(image: ima)
        imv.image = ima
        
    }
    
 
}
/*extension ViewController: VideoCaptureDelegate {
    func videoCapture(capture: VideoCapture, didCaptureVideoFrame sampleBuffer: CMSampleBuffer) {
        self.classify(sampleBuffer: sampleBuffer)
    }
}*/




extension ViewController {
    func processObservations(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNCoreMLFeatureValueObservation] {
            if results.isEmpty {
                self.resultLabel.text = "Nothing found"
            } else {
                if let confis = results[0].featureValue.multiArrayValue,let bbox = results[1].featureValue.multiArrayValue{
                    var maxcon = 0.0,maxindex = -1
                    for idx in 0..<confis.count{
                        if confis[idx].doubleValue > maxcon{
                            maxcon = confis[idx].doubleValue
                            maxindex = idx
                        }//find max
                    }
                    self.resultLabel.text = labels[maxindex]
                    self.confidenceLabel.text = String(format: "%.1f%%", maxcon * 100)
                    if let newimv = self.imv.image?.addBBox(x_min: bbox[0].doubleValue, x_max: bbox[1].doubleValue, y_min: bbox[2].doubleValue, y_max: bbox[3].doubleValue){
                        self.imv.image = newimv
                    }
                    
                }
            }
        } else if let error = error {
            self.resultLabel.text = "Error: \(error.localizedDescription)"
        } else {
            self.resultLabel.text = "???"
        }
    }
}
extension UIImage {
    func addBBox(x_min: Double, x_max: Double, y_min: Double, y_max: Double)->UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: CGPoint(x: 0, y: 0))//draw original photo
        if let context = UIGraphicsGetCurrentContext() {//get context
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(8) //set properties
            let x = x_min * Double(self.size.width), y = y_min * Double(self.size.height), width = (x_max - x_min) * Double(self.size.width), height = (y_max - y_min) * Double(self.size.height)
            context.stroke(CGRect(x: x, y: y, width: width, height: height))//add bbox
        }
        let newimv = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimv
    }
}
