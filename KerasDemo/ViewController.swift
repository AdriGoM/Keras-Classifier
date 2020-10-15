//
//  ViewController.swift
//  MDetector
//
//  Created by Adrián godoy martinez on 05/03/2020.
//  Copyright © 2020 Adrián Godoy Martínez. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        
        
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { //Optinal binding
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Unable to convert UIImage to a CIImage")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        
        guard let model = try? VNCoreMLModel(for: dog_and_cat().model) else {
            fatalError("Loading CoreML Model Failed.")
        } // Declaration of the model || guard = if my model is nil we are gonna trigger an error
        
        
        // Request to out model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            //print(results.first)
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("cat") {
                    self.navigationItem.title = "It's a cat!"
                    print(firstResult.identifier)
                    
                } else {
                    print(results.first?.identifier)
                    self.navigationItem.title = "It's a dog!"
                }
            }
        }
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print("Error")
        }
    }
}

