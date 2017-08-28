# SDWebServiceManagerSwift
SDWebServiceManager is swift 3.0 code to implement synchronous request to web server using NSURLSession for iOS.

## Installation

Just drag SDWebServiceManager.swift file in your application from the project.
The purpose of this Web service manager is to use web service code just by calling methods.

## Features
•	Synchronous request using semaphore.

•	Single method can be use for GET/POST method.

•	Basic Authentication.


## Basic usage
You have to follow the below steps:
•	Only Copy this swift file in your application.

•	All methods are class methods so don’t need to create any instance of SDWebServiceManager class.

•	Pass your URL string with parameters for GET method, you don’t need to pass data Dictionary if you are calling GET method.

•	GET is default method, you can avoid passing it if you want to use GET method.


## Implementation

### Ex.  Basic Auth Call .
```swift
        SDWebServiceManager.initwebService(JSON: loginDict as [String : AnyObject], onCompletion: {object,error,result in
        
            if error != nil
            {
                
                print("Error = %@",error?.localizedDescription);
                
            }else  if result!
            {
                
                print("\(object!)")
            
            }
            
        });

```
### Ex.  POST Method
```swift
        let result = SDWebServiceManager.sendSynchronousRequest(withUrl: "", method: "POST", andData: tokenDict as [String:String]?)
```


### Ex. Get Method
```swift
        let result = SDWebServiceManager.sendSynchronousRequest(withUrl: "", method: "POST", andData: tokenDict as [String:String]?)
```

## Requirements

• iOS8 or higher
• swift 3.0

## Author
	Firoj Shaikh.

## License
SDWebServiceManager is released under the MIT license. See the LICENSE file for more info.

