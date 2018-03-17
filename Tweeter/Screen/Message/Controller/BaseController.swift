//
//  BaseController.swift
//  Tweeter
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
class BaseController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func showErrorMessage(message:String){
        let alertController =  UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
