//
//  ViewController.swift
//  SeeFood
//
//  Created by Bhushan Joshi on 2018-03-17.
//  Copyright © 2018 Bhushan Joshi. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false //allows fucntionalities like cropping
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
        imageView.image = userPickedImage
            
            //here we are saying that if the userPickedImage can be downcasted to UIImage from type ANy then do the following.
        
            guard let ciImage = CIImage(image : userPickedImage) else{
                fatalError("Problem converting UIImage to CIImage.")
            }
            detect(image: ciImage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func detect(image : CIImage){
       guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Error loading Core ML Model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model Failed to process Image")
            }
            print(results)
            
            
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("pizza"){
                    self.navigationItem.title = "Its a Pizza !"
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                }
                else{
                    self.navigationItem.title = "Not a Pizza !"
                    self.navigationController?.navigationBar.barTintColor = UIColor.red
                }
                
                print ("Confidence :",round(firstResult.confidence*1000))
            }
            
            
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage : image)
        
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }
    
    
    
    
    
    
    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

