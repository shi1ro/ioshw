//
//  ViewController.swift
//  goodstracker
//
//  Created by njuios on 2020/11/14.
//

import UIKit
import os.log

class GoodsViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var descfield: UITextField!
    @IBOutlet weak var phiv: UIImageView!
    @IBOutlet weak var saveBut: UIBarButtonItem!
    @IBOutlet weak var cancelBut: UIBarButtonItem!
    var goods:Goods?
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isaddmodel = presentingViewController is UINavigationController
        if isaddmodel{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNaviContl = navigationController{
            owningNaviContl.popViewController(animated: true)
        }
        else{
            fatalError("The GoodsViewController is not inside a navigation controller.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        namefield.delegate = self
        descfield.delegate = self
        updateSaveButState()
        if let gds = goods {
            namefield.text = gds.name
            descfield.text = gds.desc
            phiv.image = gds.photo
        }
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem,button === saveBut else{
            os_log("save button was not pressed",log:OSLog.default,type:.debug)
            return
        }
        let name = namefield.text ?? ""
        let photo = phiv.image
        let desc = descfield.text ?? ""
        goods = Goods(name:name,desc:desc,photo: photo)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBut.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    //    namelabel.text = textField.text
        updateSaveButState()
    }
    func updateSaveButState(){
        let text = namefield.text ?? ""
        saveBut.isEnabled = !text.isEmpty
    }
 /*   @IBAction func selectimage(_ sender: UITapGestureRecognizer) {
        print(1)
        namefield.resignFirstResponder()
        descfield.resignFirstResponder()
        let imagepicker = UIImagePickerController()
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        present(imagepicker,animated:true,completion: nil)
    }*/
    
    @IBAction func selectimage(_ sender: UIButton) {
    //    print(1)
        namefield.resignFirstResponder()
        descfield.resignFirstResponder()
        let imagepicker = UIImagePickerController()
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        present(imagepicker,animated:true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true,completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image,but was provided tohe following:\(info)")
        }
        phiv.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
}

