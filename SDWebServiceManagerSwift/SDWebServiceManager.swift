//
//  SDWebServiceManager.swift
//  SDWebServiceManagerSwift
//
//  Created by Stark Digital Media Services Pvt Ltd on 07/10/16.
//  Copyright © 2016 Stark Digital Media Services Pvt Ltd. All rights reserved.
//

import UIKit

class SDWebServiceManager: NSObject {

    var webServiceHandler = {(object:Any,error:Error,success:Bool) -> Void in
    
    }
    
    class func initwebService(JSON dict: [String : AnyObject], onCompletion handler:(_ object:AnyObject?,_ error:Error?,_ success:Bool?) -> Void) {
        var json = [AnyHashable : AnyObject]()
        var mutableError: Error?
        var headers = [String : String]()
        var request = URLRequest(url: NSURL(string: "http://lc.mvpcopy.net/public/\(dict["urlVariable"] as! String)")! as URL)
        var loginString = ""
        let reachability  = Reachability()
        
        print("Current rechability status \(reachability?.currentReachabilityStatus)")
        if reachability?.currentReachabilityStatus == Reachability.NetworkStatus.notReachable {
            SDWebServiceManager.showRechabilityError()
            return
        }
        // Headers
        if dict["headers"] != nil {
            headers = dict["headers"] as! [String : String]
        }
           // Add variable to common URL
            if dict["urlVariable"] != nil {
                request = URLRequest(url: NSURL(string: "http://lc.mvpcopy.net/public/\(dict["urlVariable"] as! String)")! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
            }
            if dict["postData"] != nil {
                request.httpBody! = dict["postData"] as! Data
            }
            // Login String
            loginString = "\(dict["email"] as! String):\(dict["password"] as! String)"
            request.setValue("Basic \(loginString.data(using: String.Encoding.utf8)!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0))))", forHTTPHeaderField: "Authorization")
        
            json = SDWebServiceManager.sendSynchronous(request, error: &mutableError) as! [AnyHashable : AnyObject]
            
            if mutableError != nil {
                handler(nil, mutableError, false)
            }
            else {
                handler(json as AnyObject?, mutableError, true)
            }
        }
    
    class func sendSynchronousRequest(withUrl strUrl: String, method: String?, andData data:[String:String]?) -> [AnyHashable: AnyObject]? {
        let session = URLSession.shared
        let url = URL(string: strUrl)!
        let semaphore = DispatchSemaphore(value: 0)
        var errorResponse: Error?
        var responseData: Data?
        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        
        if method == nil
        {
              request.httpMethod = "GET"
            
        }else
        {
            request.httpMethod = method
                if data != nil {                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data!, options: JSONSerialization.WritingOptions.prettyPrinted)
                            request.httpBody = jsonData
                        print("converted");
                    } catch {
                        print("Error while encoding ")
                    }
        
                }
        }
        
       
       let dataTask = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                errorResponse = error
            }
            else {
                responseData = data
            }
            semaphore.signal()
        })
        // this code can be use for GET method
        dataTask.resume();
        
        semaphore.wait();

        do {
            if errorResponse != nil {
                print("Response Error \n \(errorResponse!.localizedDescription)")
                let strError = "\(errorResponse!.localizedDescription)"
                SDWebServiceManager.showErrorTitle("Response Error", message: strError)
                return nil
            }
            else if responseData != nil {
                let dictResult = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [AnyHashable:Any]
                
                    return dictResult as [AnyHashable : AnyObject]?
                /*let strError = "\(errorResponse!.localizedDescription)"
                SDWebServiceManager.showErrorTitle("Decode Error", message: strError)
                print("Error while decoding result data to JSON \n \(errorResponse!.localizedDescription)")
                return nil*/
            }
            
        }
        catch _ {
        }
        return nil
    }
    
    
    class func sendSynchronous(_ urlRequest: URLRequest, error:inout Error?) -> [AnyHashable: Any]? {
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        var errorResponse: Error?
        //var urlResponse: URLResponse?
        var responseData: Data?
        let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error != nil) {
                errorResponse = error
            }
            else {
                responseData = data
                //urlResponse = response
            }
            semaphore.signal()
        })
        
        dataTask.resume();
        
        semaphore.wait()
        
        do {
            if errorResponse != nil {
                print("Response Error \n \(errorResponse!.localizedDescription)")
                let strError = "\(errorResponse!.localizedDescription)"
                error = errorResponse
                SDWebServiceManager.showErrorTitle("Response Error", message: strError)
                return nil
            }
            else if responseData != nil {
                let dictResult = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [AnyHashable:Any]
                //if dictResult != nil {
                    return dictResult
                //}
                /*let strError = "\(errorResponse!.localizedDescription)"
                error = errorResponse
                SDWebServiceManager.showErrorTitle("Decode Error", message: strError)
                print("Error while decoding result data to JSON \n \(errorResponse!.localizedDescription)")
                return nil*/
            }
            
        }
        catch _ {
        }
        return nil
    }
    
    class func convertDict(toJsonString dict: [AnyHashable: Any]) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: [])
        let responseString = String(bytes: jsonData, encoding: String.Encoding.utf8)
        return responseString!
    }
     // MARK:- internet connection
    
    class func showRechabilityError() {
        SDWebServiceManager.showErrorTitle("No network connection", message: "Please try later")
    }
    // MARK:- web service error
    
    class func showErrorTitle(_ strTitle: String, message strErrorMessage: String) {
        let alertController = UIAlertController()
        alertController.title = strTitle
        alertController.message = strErrorMessage
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.preferredAction = action
        let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
        appDelegate.window!.rootViewController!.present(alertController, animated: false, completion: { _ in })
    }
}
