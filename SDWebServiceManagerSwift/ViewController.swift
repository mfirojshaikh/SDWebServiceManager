//
//  ViewController.swift
//  SDWebServiceManagerSwift
//
//  Created by Stark Digital Media Services Pvt Ltd on 07/10/16.
//  Copyright © 2016 Stark Digital Media Services Pvt Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func tabLoadData(_ sender: AnyObject) {
        
        var loginDict = [String:String]();
        loginDict["email"] = "abc@gmail.com";
        loginDict["password"] = "123456";
        loginDict["urlVariable"] = "check";
        
        SDWebServiceManager.initwebService(JSON: loginDict as [String : AnyObject], onCompletion: {object,error,result in
        
            if error != nil
            {
                
                print("Error = %@",error?.localizedDescription);
                
            }else  if result!
            {
                
                print("\(object!)")
            
            }
            
        });
    
        
        let tokenDict:Dictionary = ["name":"big","email":"big@test.com","company":"123456","big":"123456","phone":"1212121245","password":"123456"];
        

        let result = SDWebServiceManager.sendSynchronousRequest(withUrl: "", method: "POST", andData: tokenDict as [String:String]?)
        
        print("result = \(result)")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

