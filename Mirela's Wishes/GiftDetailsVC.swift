//
//  GiftDetailsVC.swift
//  Mirela's Wishes
//
//  Created by Luis  Costa on 08/02/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class GiftDetailsVC: UIViewController, UIImagePickerControllerDelegate {
    
    // IBOutlets
    @IBOutlet weak var giftImg: UIImageView!
    @IBOutlet weak var giftName: UITextField!
    @IBOutlet weak var giftPrice: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var giftStore: UITextField!
    @IBOutlet weak var giftType: UITextField!
    @IBOutlet weak var switchSMS: UISwitch!
    @IBOutlet weak var importanceSlider: UISlider!
    
    // variables
    var gift: Gift!
    var imagePicker: UIImagePickerController!
    var alreadySentSMS: Bool

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Some layout details
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
        }
        
        if let navBar = self.navigationController?.navigationBar {
            let color = UIColor(colorLiteralRed: 63/255, green: 25/255, blue: 1/255, alpha: 1)
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: color]
        }
        
        if gift != nil {
            prepareToEdit()
        }
    }
    
    func prepareToEdit() {
        if let name = gift.title {
            self.giftName.text = name
        }
        
        self.giftPrice.text = String(gift.price)
        
        if let details = gift.details {
            self.details.text = details
        }
        
        if let store = gift.shop?.name {
            self.giftStore.text = store
        }
        
        if let type = gift.type?.type {
            self.giftType.text = type
        }
        
        
        
        
        
        
        
        
        
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
