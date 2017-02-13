//
//  GiftDetailsVC.swift
//  Mirela's Wishes
//
//  Created by Luis  Costa on 08/02/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class GiftDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // IBOutlets
    @IBOutlet weak var giftImg: UIImageView!
    @IBOutlet weak var giftName: UITextField!
    @IBOutlet weak var giftPrice: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var giftStore: UITextField!
    @IBOutlet weak var giftType: UITextField!
    @IBOutlet weak var switchSMS: UISwitch!
    @IBOutlet weak var importanceSlider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    
    // variables
    var gift: Gift?
    // Select images from the device
    var imagePicker: UIImagePickerController!
    var alreadySent = false
    
    /* 
     Main function
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Image Picker
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if gift != nil {
            prepareToEdit()
        }
    }
    
    func prepareToEdit() {
        if let name = gift!.title {
            self.giftName.text = name
        }
        
        self.giftImg.image = gift!.photo?.photo as? UIImage
        self.giftPrice.text = String(gift!.price)
        
        if let details = gift!.details {
            self.details.text = details
        }
        
        if let store = gift!.shop?.name {
            self.giftStore.text = store
        }
        
        if let type = gift!.type?.type {
            self.giftType.text = type
        }
        
        self.switchSMS.setOn(gift!.sentSMS, animated: true)
        if self.switchSMS.isOn {
            self.alreadySent = true
        }
        self.importanceSlider.value = Float(gift!.importance)
        let value = Int(self.importanceSlider.value)
        self.sliderValue.text = "\(value)"
    }
    
    
    /* 
     Apply some layout detains in navigation bar
     */
    func applyLayout() {
        
        // Some layout details
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
        }
        
        if let navBar = self.navigationController?.navigationBar {
            let color = UIColor(colorLiteralRed: 63/255, green: 25/255, blue: 1/255, alpha: 1)
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: color]
        }
    }
    
    /* 
     Function to add an image
     */
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
     Associate image from photo library to the Gift photo
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.giftImg.image = image
        }
        
        // Dismiss
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    /* 
     Function to ave an edited gift or a new gift
     */
    @IBAction func saveGiftPressed(_ sender: UIButton) {
        
        var newGift: Gift!
        
        if gift != nil {
           newGift = gift
            
        } else {
            // Create a new gift
            newGift = Gift(context: context)
        }
        
        let photo = Photo(context: context)
        
        if let img = self.giftImg.image {
            photo.photo = img
            newGift.photo = photo
        }
        
        if let title = self.giftName.text {
            newGift.title = title
        }
       
        if let pricetext = self.giftPrice.text {
            newGift.price = (pricetext as NSString).doubleValue
        }
        
        if let details = self.details.text {
            newGift.details = details
        }
        
        newGift.importance = Int32(self.importanceSlider.value)
        
        let shop = Shop(context: context)
        if let shopName = self.giftStore.text {
            shop.name = shopName
            newGift.shop = shop
        }
        
        let type = Type(context: context)
        if let typeName = self.giftType.text {
            type.type = typeName
            newGift.type = type
        }
        
        newGift.sentSMS = self.switchSMS.isOn
        
        // saving objects
        ad.saveContext()
        
        // Compose msg
        if newGift.sentSMS && !alreadySent {
            let result = sendSMS(newGift: newGift)
            //let result = true
            
            if result {
                print("Enviada")
                // perform the alert
                //applyAlert()
                let alertController = UIAlertController(title: "Message sent", message: "Your boyfriend got your request", preferredStyle: UIAlertControllerStyle.actionSheet)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                    (alert: UIAlertAction!) in
                    // Back to main View
                    _ = self.navigationController?.popViewController(animated: true)}))
                
                // Show thr alert
                self.present(alertController, animated: true, completion: nil)
        
            } else {
                print("Nao enviada")
                _ = self.navigationController?.popViewController(animated: true)
                
            }
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    /* 
     Show slide value on buttom label
     */
    @IBAction func slidderTapped(_ sender: Any) {
        sliderValue.text = "\(Int(importanceSlider.value))"
    }
    
    /* 
     Function to delete the current gift
     */
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        // Delete the current item
        if gift != nil {
            context.delete(gift!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    /* 
     Function to send the message
     */
    func sendSMS(newGift: Gift) -> Bool {
        let controller: MessageController!
        var text = "New Gift added! Name: "
        
        text.append(newGift.title!)
        text.append(" Price: ")
        text.append("\(newGift.price)")
        text.append(" Store: ")
        text.append((newGift.shop?.name)!)
        
        var message = Message()
        message.text = text
        message.sendTo = "telephone_number"
        
        // Sending SMS
        controller = MessageController()
        let result = controller.sendSMS(msg: message)
        
        if result.contains("Error") || result.contains("Invalid") {
            return false
        }
        return true
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
