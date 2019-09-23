//
//  CommonErrorAlert.swift
//  KeyofLife
//
//  Created by MacMini on 06/09/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class CommonErrorAlert: NSObject
{
    func alert(info:String, viewController: UIViewController)
    {
        
        let popUp = UIAlertController(title: APP_NAME, message: info, preferredStyle: UIAlertController.Style.alert)
        popUp.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {(action:UIAlertAction!) in
            
            
                          popUp.dismiss(animated: true, completion: nil)
           
           
            
        }))
        viewController.present(popUp, animated: true, completion: nil)
    }
    
    

}
