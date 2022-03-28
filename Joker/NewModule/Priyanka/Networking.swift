//
//  Networking.swift
//  E-RX
//
//  Created by SinhaAirBook on 29/06/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
 /*
 Enum uses in API

 */
enum Result<Value: Decodable> {
    case success(Value)
    case failure(Error)
}

typealias Handler = (Result<JSON>) -> Void



enum NetworkError: Error {
    case nullData
}


public enum Method {
   
    case delete
    case get
    case head
    case post
    case put
    case connect
    case options
    case trace
    case patch
    case other(method: String)
}

enum NetworkingError: String, LocalizedError {
    case jsonError = "JSON error"
    case other
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}

extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
        case "DELETE":
            self = .delete
        case "GET":
            self = .get
        case "HEAD":
            self = .head
        case "POST":
            self = .post
        case "PUT":
            self = .put
        case "CONNECT":
            self = .connect
        case "OPTIONS":
            self = .options
        case "TRACE":
            self = .trace
        case "PATCH":
            self = .patch
        default:
            self = .other(method: method)
        }
    }
}

extension Method: CustomStringConvertible {
    public var description: String {
        switch self {
        case .delete:            return "DELETE"
        case .get:               return "GET"
        case .head:              return "HEAD"
        case .post:              return "POST"
        case .put:               return "PUT"
        case .connect:           return "CONNECT"
        case .options:           return "OPTIONS"
        case .trace:             return "TRACE"
        case .patch:             return "PATCH"
        case .other(let method): return method.uppercased()
        }
    }
}

extension Method{
    
    var method:HTTPMethod{
        
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .connect:
            return .connect
        case .delete:
            return .delete
        case .head:
            return .head
        case .options:
            return .options
        case .patch:
            return .patch
        case .put:
            return .put
        case .trace:
            return .trace
        
        case .other( _):
            return .head
        }
    }
    
}

protocol Requestable {}

extension Requestable{
    
    
    // For Post and Get Method
    
    internal func request(method: Method, url: String, params: [String: Any]? = nil,headers:[String:String]? = nil, callback: @escaping Handler){
        
        
        guard let url = URL(string: url) else {
            return
        }
        var Headers = [String:String]()
        Headers = headers?.compactMapValues({ value in
            return value
        }) ?? [:]
//        Headers["langCode"] = Localize.currentLanguage()
        
        var request = URLRequest(url: url)
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        var header : HTTPHeaders = HTTPHeaders()
        
        for (k,v) in Headers {
            
            header.add(name: k, value: v)
            
        }
        
        AF.request(url, method: method.method , parameters: params, encoding: JSONEncoding.default, headers:header).responseJSON { (responseObject) -> Void in
            
            switch responseObject.result{
                
            case .success(_):
                
                let resJson = JSON(responseObject.value!)
                callback(.success(resJson))
                
            case .failure(_):
                
                let error : Error = responseObject.error!
             
                    callback(.failure(error))
            }
            
        }
    }
    
   // For Multiparting
    
    internal func multipartingRequest(imageData:[NSData]? = nil,fileName:[String]? = nil , imageParam:[String]? = nil,url: String, params: [String: Any]? = nil,headers:[String:String]? = nil, callback: @escaping Handler){
        
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(ContentType.multipart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        var Headers = [String:String]()
               Headers = headers?.compactMapValues({ value in
                   return value
               }) ?? [:]
        Headers["langCode"] = Localize.currentLanguage()
        var header : HTTPHeaders = HTTPHeaders()
        
        for (k,v) in Headers{
            
            header.add(name: k, value: v)
            
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if imageData?.count ?? 0 > 0{
                for i in 0..<imageData!.count{
                    let imagedata = imageData![i] as Data
                    multipartFormData.append(imagedata as Data, withName: imageParam?[i] ?? "", fileName: fileName?[i], mimeType:"image/png")
                }
            }
            
            for (key, value) in params! {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
            
        },to: url, usingThreshold:UInt64.init(), method: .post, headers: header).responseJSON { (response) in
            
            switch response.result{
                
            case .success(_):
                
                let resJson = JSON(response.value!)
                callback(.success(resJson))
                
            case .failure(_):
                
                let error : Error = response.error!
                
                callback(.failure(error))
                
            }
        }
    }
    
}

// SINGLTON CLASS FOR SCREEN NAME  that on That screen notification popup will not come
class ScreeNNameClass {
    static let shareScreenInstance = ScreeNNameClass()
    var  screenName = ""
    private init() {}
}
