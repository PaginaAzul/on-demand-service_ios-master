//
//  webserviceClass.swift
//  Copyright © 2016 Apple. All rights reserved.

import Foundation
import UIKit
import AFNetworking


enum methodType {
    
    case post,get
}

class webservices {
    
    // MARK: Singleton Instance
    
    static let sharedInstance : webservices = {
        let instance = webservices()
        
        return instance
        
    }()
    
    
    var responseCode = 0;
    
    func startConnectionWithText(_ getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPSessionManager()
            
            manager.operationQueue.cancelAllOperations()
            
            manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
            
            // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
            
            let url = baseURL + (getUrlString as String)
            print(url)
            
            
            manager.post(url as String, parameters: getParams, headers: nil, progress: nil, success: { (sessionTask, responseObject) in
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    // print("JSON: " + responseObject.description)
                    
                }
            }, failure: { (sessionTask, error: Error?) in
                self.responseCode = 2
                
                let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                
                outputBlock(errorDist);
                
                print("Error: " + (error?.localizedDescription)!)
            })
            
            /*
             manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
             
             if(responseObject != nil){
             
             self.responseCode = 1
             
             outputBlock(responseObject! as! NSDictionary);
             
             // print("JSON: " + responseObject.description)
             
             }
             
             },
             
             failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
             
             self.responseCode = 2
             
             let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
             
             outputBlock(errorDist);
             
             print("Error: " + (error?.localizedDescription)!)
             
             })
             
             */
        }
    }
    
    // MARK: POST
    
    func startConnectionWithSting(_ getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPSessionManager()
            
            manager.operationQueue.cancelAllOperations()
            
            
            
          //  manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
            
            //manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            //    manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                
                let type_token = UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""
                
                print(type_token)
                
                manager.requestSerializer.setValue(type_token, forHTTPHeaderField: "token")
                
            }
            
            
            manager.requestSerializer.timeoutInterval = 120
            
            let url = baseURL + (getUrlString as String)
            
            print(url)
            
            manager.post(url as String, parameters: getParams, headers: nil, progress: nil, success: { (sessionTask, responseObject) in
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    // print("JSON: " + responseObject.description)
                }
                
            },
                         
                         failure: { (sessionTask, error: Error?) in
                            
                            self.responseCode = 2
                            
                            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                            
                            outputBlock(errorDist);
                            
                            print("Error: " + (error?.localizedDescription)!)
                            
            })
            
            /*
             manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
             
             if(responseObject != nil){
             
             self.responseCode = 1
             
             outputBlock(responseObject! as! NSDictionary);
             
             // print("JSON: " + responseObject.description)
             }
             
             },
             
             failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
             
             self.responseCode = 2
             
             let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
             
             outputBlock(errorDist);
             
             print("Error: " + (error?.localizedDescription)!)
             
             })
             
             */
        }
    }
    
    // MARK: POST without token
    
    func startConnectionWithStingWithoutToken(_ getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            //
            
            
            //
            let manager = AFHTTPSessionManager()
            
            manager.operationQueue.cancelAllOperations()
          //  manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
            
            manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
            //manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            //    manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            manager.requestSerializer.timeoutInterval = 120
            
            let url = baseURL + (getUrlString as String)
            
            print(url)
            
            manager.post(url as String, parameters: getParams, headers: nil, progress: nil, success: { (sessionTask, responseObject) in
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                }
            }, failure: { (sessionTask, error: Error?) in
                self.responseCode = 2
                
                let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                
                outputBlock(errorDist);
                
                print("Error: " + (error?.localizedDescription)!)
            })
            
            /*
             manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
             
             if(responseObject != nil){
             
             self.responseCode = 1
             
             outputBlock(responseObject! as! NSDictionary);
             
             // print("JSON: " + responseObject.description)
             }
             
             },
             
             failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
             
             self.responseCode = 2
             
             let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
             
             outputBlock(errorDist);
             
             print("Error: " + (error?.localizedDescription)!)
             
             })
             */
            
        }
    }
    
    
    //////////////
    
    
    func startConnectionWithSting_ForDictonary(_ getUrlString:NSString ,method_type:methodType, params getParams:[String:String],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPSessionManager()
            
            manager.operationQueue.cancelAllOperations()
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
            
            //manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            //   manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            let url = baseURL + (getUrlString as String)
            
            print(url)
            
            
            manager.post(url as String, parameters: getParams, headers: nil, progress: nil, success: { (sessionTask, responseObject) in
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    // print("JSON: " + responseObject.description)
                }
                
            }, failure: { (sessionTask, error: Error?) in
                self.responseCode = 2
                
                let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                
                outputBlock(errorDist);
                
                print("Error: " + (error?.localizedDescription)!)
            })
            
            /*
             manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
             
             if(responseObject != nil){
             
             self.responseCode = 1
             
             outputBlock(responseObject! as! NSDictionary);
             
             // print("JSON: " + responseObject.description)
             }
             
             },
             
             failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
             
             self.responseCode = 2
             
             let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
             
             outputBlock(errorDist);
             
             print("Error: " + (error?.localizedDescription)!)
             
             })
             
             */
            
        }
    }
    
    //  Mark service for Document Picker
    
    func startConnectionWithFile(imageData:NSData,fileName:String,filetype:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
        
        //  manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        //        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        
        /*
         manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
         
         formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
         
         }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
         
         if(responseObject != nil){
         
         self.responseCode = 1
         
         outputBlock(responseObject! as! NSDictionary);
         
         }
         
         }, failure: { (operation:AFHTTPRequestOperation?, error:
         Error?) -> Void in
         
         self.responseCode = 2
         
         let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
         
         outputBlock(errorDist);
         
         })
         
         */
    }
    
    // method for split dictionary & then upload a document
    
    func startConnectionWithFile_uploadDict(imageData:NSData,fileName:String,filetype:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[String:String],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        
        //manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        // manager.requestSerializer.setValue("token", forHTTPHeaderField: "X-Auth-Token")
        
        //manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
            
        }, progress: nil,  success: { (sessionTask, responseObject) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (sessionTask, error: Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
        
        
    }
    
    
    
    
    // for two documents uploadation,1 user Image
    
    
    func startConnectionWithFile1(imageData:NSData,imageData1:NSData,fileName:String,fileName1:String,filetype:String,filetype1:String,imageparm:String,imageparm1:String,userImage:NSData,userImageName:String,userImageParam:String,userImageFileType:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) in
            
            if imageData.length > 0{
                formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
            }
            
            if imageData1.length > 0{
                formData!.appendPart(withFileData: imageData1 as Data!, name:imageparm1, fileName: fileName1, mimeType: filetype1)
            }
            
            if userImage.length > 0{
                formData!.appendPart(withFileData: userImage as Data!, name:userImageParam, fileName: userImageName, mimeType: userImageFileType)
            }
            
        }, progress: nil, success: { (sessionTask, responseObject) in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }) { (sessionTask, error: Error?) in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
        }
        
        /*
         manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
         
         if imageData.length > 0{
         formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
         }
         
         if imageData1.length > 0{
         formData!.appendPart(withFileData: imageData1 as Data!, name:imageparm1, fileName: fileName1, mimeType: filetype1)
         }
         
         if userImage.length > 0{
         formData!.appendPart(withFileData: userImage as Data!, name:userImageParam, fileName: userImageName, mimeType: userImageFileType)
         }
         
         }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
         
         if(responseObject != nil){
         
         self.responseCode = 1
         
         outputBlock(responseObject! as! NSDictionary);
         
         }
         
         }, failure: { (operation:AFHTTPRequestOperation?, error:
         Error?) -> Void in
         
         self.responseCode = 2
         
         let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
         
         outputBlock(errorDist);
         
         })
         
         */
    }
    
    
    
    
    //    func otpConnection(_ getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
    //
    //        DispatchQueue.global().async {
    //
    //            let manager = AFHTTPRequestOperationManager()
    //
    //            manager.operationQueue.cancelAllOperations()
    //
    //            manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as Set<NSObject>
    //
    //            //manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
    //
    //            //manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
    //
    //            let url = MsgUrl// + (getUrlString as String)
    //
    //            print(url)
    //
    //            manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
    //
    //                if(responseObject != nil){
    //
    //                    self.responseCode = 1
    //
    //                    outputBlock(responseObject! as! NSDictionary);
    //
    //                    // print("JSON: " + responseObject.description)
    //                }
    //
    //            },
    //
    //                         failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
    //
    //                            self.responseCode = 2
    //
    //                            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
    //
    //                            outputBlock(errorDist);
    //
    //                            print("Error: " + (error?.localizedDescription)!)
    //
    //            })
    //
    //        }
    //    }
    
    
    
    /// MARK: use for google map api
    
    
    func startConnectionWithStringGetTypeGoogle(getUrlString: NSString, outputBlock: @escaping (_ receivedData:NSDictionary)->Void) {
        
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.timeoutInterval = 180
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        let url = (getUrlString as String)
        
        manager.get(url as String, parameters: nil,headers: nil, progress:nil , success: { (sessionTask, responseObject) in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary)
                
                
            }
            
            
        }, failure: { (sessionTask, error: Error?) in
            
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            
            outputBlock(errorDist)
            
            
            
        })
        
        
    }
    
    
    
    func startConnectionWithSingleFile(_ imageData:NSData,fileName:String,filetype:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPSessionManager()
            
            
            manager.operationQueue.cancelAllOperations()
            
            // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
            
            let url = baseURL + (getUrlString as String)
            
            manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
                //code
                
                if imageData.length > 0{
                    
                    formData!.appendPart(withFileData: imageData as Data!, name: "file", fileName: fileName, mimeType: filetype)
                }
                
            }, progress:nil , success: { (sessionTask, responseObject) -> Void in
                
                print(responseObject)
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    // print("JSON: " + responseObject.description)
                }
                
            }, failure: { (sessionTask, error: Error?) -> Void in
                
                self.responseCode = 2
                
                let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                
                outputBlock(errorDist);
                
                print(error!)
                
            })
            
        }
        
    }
    
    // get type webservice
    
    func startConnectionWithStringGetType(getUrlString:NSString ,outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        
        //manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        //        manager.responseSerializer.acceptableContentTypes = NSSet (object: "text/html") as Set<NSObject>
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        
        //manager.responseSerializer.acceptableContentTypes = NSSet(set: "text/html")
        //        manager.responseSerializer.acceptableContentTypes=NSSet (object: "text/html") as Set<NSObject>
        
        let url = baseURL + (getUrlString as String)
        
        print(url)
        
        manager.get(url as String, parameters: nil,headers: nil, progress:nil , success: { (sessionTask, responseObject) in
            
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
                // print("JSON: " + responseObject.description)
            }
        }, failure: { (sessionTask, error: Error?) in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
            print("Error: " + (error?.localizedDescription)!)
        })
        
    }
    
    
    func startConnectionWithData(imageData:NSData,fileName:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
        
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: "image/jpeg")
            
        }, progress:nil, success: { (sessionTask, responseObject) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (sessionTask, error: Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    func startConnectionWithfile1(_ imageData:NSMutableArray,imageParam:String,filetype:String,videoData:NSMutableArray,videoParam:String,videoFileType:String,getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPSessionManager()
            
            manager.operationQueue.cancelAllOperations()
            
            manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
            //manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            let url = baseURL + (getUrlString as String)
            
            manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
                //code
                
                for i in 0..<imageData.count{
                    
                    let imagedata:Data = imageData[i] as! Data
                    
                    let strname = "UserImg.jpg"
                    
                    formData?.appendPart(withFileData: imagedata, name: imageParam, fileName: strname, mimeType: filetype)
                    
                }
                
                
                for i in 0..<videoData.count{
                    
                    let imagedata1:Data = videoData[i] as! Data
                    
                    let strname = "video\(i).mp4"
                    
                    formData?.appendPart(withFileData: imagedata1, name: videoParam, fileName: strname, mimeType: videoFileType)
                }
                
            }, progress:nil, success: { (sessionTask, responseObject) -> Void in
                
                //  print(responseObject)
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    print("JSON: " + (responseObject as AnyObject).description)
                }
                
            }, failure: { (sessionTask, error: Error?) -> Void in
                
                self.responseCode = 2
                
                let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                
                outputBlock(errorDist);
                
                print(error!)
                
            })
            
        }
    }
    
    
    func startConnectionWithEditProfileService(imageData:NSData,imageData1:NSData,fileName:String,fileName1:String,filetype:String,filetype1:String,imageparm:String,imageparm1:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
        
        //  manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
                formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
            }
            
            if imageData1.length > 0{
                formData!.appendPart(withFileData: imageData1 as Data!, name:imageparm1, fileName: fileName1, mimeType: filetype1)
            }
            
            
        }, progress:nil, success: { (sessionTask, responseObject) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (sessionTask, error: Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    
    ///////////
    
    func startConnectionWithProfileData(imageData:NSData,fileName:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let type_token = UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""
            
            manager.requestSerializer.setValue(type_token, forHTTPHeaderField: "token")
            
        }
        
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
                
                formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: "file.png", mimeType: "image/png")
                
                //  formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: imageparm, mimeType: "image/png")
            }
            
        }, progress:nil, success: { (sessionTask, responseObject) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (sessionTask, error: Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    //////////
    
    func startConnectionWithProfileDataWithArray(imageData:NSData,fileName:String,imageparm:String, getUrlString:NSString,fileArr:NSMutableArray,ArrayParam:String,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
        
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        //  manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
                
                formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: "image/jpeg")
            }
            
            if fileArr.count != 0{
                
                for i in 0..<fileArr.count{
                    
                    let imagedata = fileArr[i] as! Data
                    
                    formData!.appendPart(withFileData: imagedata, name:ArrayParam, fileName: "foodImage.jpg", mimeType: "image/jpeg")
                }
            }
            
        }, progress:nil, success: { (sessionTask, responseObject) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (sessionTask, error: Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    
    //:::::::::::::::::::::::::::
    
    func startConnectionWithArray(getUrlString:NSString,fileArr:NSMutableArray,ArrayParam:String,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        //manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if fileArr.count != 0{
                
                for i in 0..<fileArr.count{
                    
                    let imagedata = fileArr[i] as! Data
                    
                    formData!.appendPart(withFileData: imagedata, name:ArrayParam, fileName: ArrayParam, mimeType: "image/jpeg")
                }
            }
            
        }, progress:nil, success: { (sessionTask, responseObject) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (sessionTask, error: Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    
    /////////////////////////////
    
    func startConnectionWithStringGetTypeInsta(getUrlString:NSString ,outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        //   manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        let url = (getUrlString as String)
        
        print(url)
        
        manager.get(url as String, parameters: nil ,headers: nil, progress: nil, success: { (sessionTask, responseObject) in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
                // print("JSON: " + responseObject.description)
            }
        }, failure: { (sessionTask, error: Error?) in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
            print("Error: " + (error?.localizedDescription)!)
        })
        
    }
    
    //:::::::::::::::::::::::::::
    
    
    
    func startConnectionWithFiveFile(imageData:NSData,uploadId1data:NSData,uploadId2Data:NSData,UploadId3data:NSData,uploadId4Data:NSData,profileParam:String,uploadId1Param:String,uploadId2Param:String,uploadId3Param:String,uploadId4Param:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.operationQueue.cancelAllOperations()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        
        //  manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        //  manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let type_token = UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""
            
            print(type_token)
            
            manager.requestSerializer.setValue(type_token, forHTTPHeaderField: "token")
            
        }
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, headers: nil, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
                formData!.appendPart(withFileData: imageData as Data!, name:profileParam, fileName: "profile.png", mimeType: "image/jpeg")
            }
            
            if uploadId1data.length > 0{
                formData!.appendPart(withFileData: uploadId1data as Data!, name:uploadId1Param, fileName: "id1.png", mimeType: "image/jpeg")
            }
            
            if uploadId2Data.length > 0{
                formData!.appendPart(withFileData: uploadId2Data as Data!, name:uploadId2Param, fileName: "id2.png", mimeType: "image/jpeg")
            }
            
            if UploadId3data.length > 0{
                formData!.appendPart(withFileData: UploadId3data as Data!, name:uploadId3Param, fileName: "id3.png", mimeType: "image/jpeg")
            }
            
            if uploadId4Data.length > 0{
                formData!.appendPart(withFileData: uploadId4Data as Data!, name:uploadId4Param, fileName: "id4.png", mimeType: "image/jpeg")
            }
            
        }, progress:nil, success: { (sessionTask, responseObject) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (sessionTask, error: Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    
    //::::::::::::::::::::::::::
    
    // MARK: POST without token
    
    func startConnectionWithStingWithJson(_ getUrlString:NSString ,method_type:methodType, params getParams:[String:Any],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPSessionManager()
            
            manager.operationQueue.cancelAllOperations()
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
            
            // manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            //    manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            
            var jsonParam = ""
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: getParams, options: JSONSerialization.WritingOptions.prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let theJSONText = String(data: jsonData, encoding: String.Encoding.ascii)
                
                jsonParam = theJSONText ?? ""
                
            } catch let error as NSError {
                print(error)
            }
            
            
            
            ////
            
            manager.requestSerializer.timeoutInterval = 120
            
            let url = (getUrlString as String)
            
            print(url)
            
            manager.post(url as String, parameters: jsonParam, headers: nil, progress:nil, success: { (sessionTask, responseObject) in
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    // print("JSON: " + responseObject.description)
                }
                
            },
                         
                         failure: { (sessionTask, error: Error?) in
                            
                            self.responseCode = 2
                            
                            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                            
                            outputBlock(errorDist);
                            
                            print("Error: " + (error?.localizedDescription)!)
                            
            })
            
        }
    }
    
    /////
    
    
    
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
