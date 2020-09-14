//
//  ViewController.swift
//  SeeFood-CoreML
//
//  Created by Angela Yu on 27/06/2017.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Social


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var classificationResults : [VNClassificationObservation] = []
    let imagePicker = UIImagePickerController()
    private var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    func detect() {
        
        let model = food_mlmodel()
        
        let food_labels = ["ChicFila_crispy_chicken_sandwich","ChicFila_milk_shake","ChicFila_nuggets","ChicFila_sidesalad","ChicFila_waffle_fries",
          "apple_pie","baby_back_ribs","baklava","bruschetta","butter_garlic_shrimp","cannoli","cappuccino","cheesecake",
          "chicken_curry","chicken_wings","chocolate_cake","churros","club_sandwich","corn_on_the_cob","croque_madame","cup_cakes",
          "deviled_eggs","donuts","dumplings","edamame","escargots","falafel","french_fries","garlic_bread","gnocchi","guacamole",
          "hot_dog","hummus","ice_cream","jalebi","lasagna","lobster_roll_sandwich","macaroni_and_cheese","macarons","mango_lassi",
          "mcd_french_fries","mussels","oysters","pancakes","panna_cotta","prime_rib","samosa","sashimi","sea_urchin","whole_boiled_crab"]
          
          let calorie_class : [String:String] = [
          "Class10" : "235-240",
          "Class11": "241-260",
          "Class12": "261-265",
          "Class13": "281-290",
          "Class14": "320-325",
          "Class15" : "311-315",
          "Class16": "350-355",
          "Class18": "395-400",
          "Class2": "70-75",
          "Class3": "100-105",
          "Class4": "111-120",
          "Class5": "130-135",
          "Class6": "140-149",
          "Class7": "160-179",
          "Class9": "200-210",
          "Class17": "221-225",
          "Class19": "300-305",
          "Class20": "185-200",
          "Class21": "230-235",
          "Class22": "226-230",
          "Class23" : "150-159",
          "Class24" : "90-95",
          "Class25" : "600-800",
          "Class26" : "290-300",
          "Class27" : "440-460",
          "Class28" : "400-420",
          "Class29" : "520-550"
          ]
          
        //  let currentImageName = "Cheesecake"
          
        guard let img = self.image,
          let resizedImage = img.resizeTo(size: CGSize(width: 224, height: 224)),
              let buffer = resizedImage.toBuffer() else{
                  return
               }
          
          var class_prob = Dictionary<String, Double>()
          
          let pred = try? model.prediction(image: buffer)
          
          if let pred_prob = pred {
              class_prob = pred_prob.output
              
              var max_food_pred:Double = 0.0
              var max_cal_pred:Double = 0.0
              var food_pred = [Double:String]()
              var cal_pred = [Double:String]()
              
              for(class_name, prob) in class_prob {
                  if(food_labels.contains(class_name)){
                      food_pred[prob] = class_name
                  }
                  else{
                      cal_pred[prob] = class_name
                  }
              }
              
              max_food_pred = food_pred.keys.max()!
              max_cal_pred = cal_pred.keys.max()!
              
              let food:String = food_pred[max_food_pred]!
              let max_cal_class:String = cal_pred[max_cal_pred]!
              
              let calorie:String = calorie_class[max_cal_class]!
              
              let food_cal:String = food + calorie
            
              self.navigationItem.title = food_cal
             // self.classificationCalorie = calorie
          }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            self.image = userPickedImage
            imagePicker.dismiss(animated: true, completion: nil)
           // guard let ciImage = CIImage(image: image) else {
           //     fatalError("couldn't convert uiimage to CIImage")
           // }
            detect()
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
