//
//  HttpRequestManager.swift
//  SwiftDemo
//
//  Created by C79 on 16/04/16.
//  Copyright © 2016 Narolainfotech. All rights reserved.
//

import UIKit
import Alamofire
//Encoding Type
let URL_ENCODING = URLEncoding.default
let JSON_ENCODING = JSONEncoding.default

//Web Service Result 
let WSSTATUS = "status"
let WSMESSAGE = "message"
let WSDATA = "data"

public enum RESPONSE_STATUS : NSInteger
{
    case INVALID
    case VALID
    case MESSAGE
}

protocol UploadProgressDelegate
{
    func didReceivedProgress(progress:Float)
}
protocol DownloadProgressDelegate
{
    func didReceivedDownloadProgress(progress:Float,filename:String)
    func didFailedDownload(filename:String)
}

class HttpRequestManager
{
    static let sharedInstance = HttpRequestManager()
    let additionalHeader = ["User-Agent": "iOS",
                            "Access-Key":"nousername",
                            "Secret-Key":"uv59I7NrSn8OuklPQw1px/vQfIeFEx5IaFYhWHD+O60=",
                            "accept":"application/json",
                            "apikey":"065158d0-d6b7-41a5-8ce5-8d9ea7da5c54"]
    var responseObjectDic = Dictionary<String, AnyObject>()
    var URLString : String!
    var Message : String!
    var resObjects:AnyObject!
    var alamoFireManager = Alamofire.SessionManager.default
    var delegate : UploadProgressDelegate?
    var downloadDelegate : DownloadProgressDelegate?
    
    
    // METHODS
    init()
    {
       // alamoFireManager.session.configuration.timeoutIntervalForRequest = 120 //seconds
       // alamoFireManager.session.configuration.httpAdditionalHeaders = additionalHeader
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = (5 * 60) // seconds
        configuration.timeoutIntervalForResource = (5 * 60) //seconds
        configuration.httpAdditionalHeaders = additionalHeader
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
      //  alamoFireManager.session.configuration.httpAdditionalHeaders = additionalHeader
    }
    
    //MARK:- POST Request
    func postJSONRequest(endpointurl:String, parameters:NSDictionary, encodingType:ParameterEncoding = JSONEncoding.default, responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        ShowNetworkIndicator(xx: true)
        
        print("request parameter:\(parameters)")
        alamoFireManager.request(endpointurl, method: .post, parameters: parameters as? Parameters, encoding: encodingType, headers: additionalHeader)
            
            .responseJSON { (response:DataResponse<Any>) in
                
                self.ShowNetworkIndicator(xx: false)
                
            if let _ = response.result.error
            {
                responseData(nil, response.result.error as NSError?,MESSAGE)
            }
            else
            {
                switch(response.result)
                {
                    
                case .success(_):
                    if let data = response.result.value
                    {
                        print("response result:\(data)")
                        self.Message = (data as! NSDictionary)[WSMESSAGE].asStringOrEmpty()
                        let responseStatus = (data as! NSDictionary)[WSSTATUS].aIntOrEmpty()
                        switch (responseStatus) {
                            
                        case RESPONSE_STATUS.VALID.rawValue :
                            self.resObjects = (data as! NSDictionary) as AnyObject
                            break
                            
                        case RESPONSE_STATUS.INVALID.rawValue :
                            self.resObjects = nil
                            break
                            
                        default :
                            break
                        }
                        responseData(self.resObjects, nil, self.Message)
                    }
                    break
                case .failure(_):
                    responseData(nil, response.result.error as NSError?, MESSAGE)
                    break
                }
            }
        }
    }
    
    //MARK:- GET Request
    func getRequestWithoutParams(endpointurl:String,responseData:@escaping (_ data:AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        ShowNetworkIndicator(xx: true)
        
        alamoFireManager.request(endpointurl, method: .get).responseJSON { (response:DataResponse<Any>) in
            self.ShowNetworkIndicator(xx: false)
            
            if let _ = response.result.error
            {
                responseData(nil, response.result.error as NSError?,MESSAGE)
            }
            else
            {
                switch(response.result)
                {
                case .success(_):
                    if let data = response.result.value
                    {
                        self.Message = (data as! NSDictionary)[WSMESSAGE].asStringOrEmpty()
                        let responseStatus = (data as! NSDictionary)[WSSTATUS].aIntOrEmpty()
                        switch (responseStatus) {
                            
                        case RESPONSE_STATUS.VALID.rawValue :
                            self.resObjects = (data as! NSDictionary) as AnyObject
                            break
                            
                        case RESPONSE_STATUS.INVALID.rawValue :
                            self.resObjects = (data as! NSDictionary) as AnyObject
                            break
                            
                        default :
                            break
                        }
                        responseData(self.resObjects, nil, self.Message)
                    }
                    break
                    
                case .failure(_):
                    responseData(nil, response.result.error as NSError?,MESSAGE)
                    break
                    
                }
            }
        }
    }
    
    func getRequest(endpointurl:String,parameters:NSDictionary,responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        ShowNetworkIndicator(xx: true)
        alamoFireManager.request(endpointurl, method: .get, parameters: parameters as? [String : AnyObject]).responseJSON { (response:DataResponse<Any>) in
            self.ShowNetworkIndicator(xx: false)
            
            if let _ = response.result.error
            {
                responseData(nil, response.result.error as NSError?, MESSAGE)
            }
            else
            {
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value
                    {
                        self.Message = (data as! NSDictionary)[WSMESSAGE].asStringOrEmpty()
                        let responseStatus = (data as! NSDictionary)[WSSTATUS].aIntOrEmpty()
                        switch (responseStatus) {
                            
                        case RESPONSE_STATUS.VALID.rawValue :
                            self.resObjects = (data as! NSDictionary) as AnyObject
                            break
                            
                        case RESPONSE_STATUS.INVALID.rawValue :
                            //self.resObjects = nil
                            self.resObjects = (data as! NSDictionary) as AnyObject
                            break
                            
                        default :
                            break
                        }
                        responseData(self.resObjects, nil, self.Message)
                    }
                    break
                    
                case .failure(_):
                    responseData(nil, response.result.error as NSError?, MESSAGE)
                    break
                    
                }
            }
        }
        
    }
//    func getAddressFromLatLongetRequest(lat:Float,long:Float,responseData:@escaping (_ address: String?) -> Void) {
//
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double(lat)
//        //21.228124
//        let lon: Double = Double(long)
//        //72.833770
//
//        center.latitude = lat
//        center.longitude = lon
//        var addressString : String = ""
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//        locationAddress (loc:loc,responseData:{(address) in
//            addressString = address!
//
//        })
//        return responseData(addressString)
//
//    }
//    func locationAddress (loc:CLLocation,responseData:@escaping (_ address: String?) -> String)
//    {
//         var addressString : String = ""
//          let ceo: CLGeocoder = CLGeocoder()
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//            {(placemarks, error) in
//                if (error != nil)
//                {
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                let pm = placemarks! as [CLPlacemark]
//
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//                    //                    print(pm.country)
//                    //                    print(pm.locality)
//                    //                    print(pm.subLocality)
//                    //                    print(pm.thoroughfare)
//                    //                    print(pm.postalCode)
//                    //                    print(pm.subThoroughfare)
//
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//
//
//                    print(addressString)
//
//                    //                   return  addressString
//                }
//               return responseData(addressString)
//        })
//    }
    func getRequest1(endpointurl:String,parameters:NSDictionary,responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        ShowNetworkIndicator(xx: true)
        alamoFireManager.request(endpointurl, method: .get, parameters: parameters as? [String : AnyObject]).responseJSON { (response:DataResponse<Any>) in
            self.ShowNetworkIndicator(xx: false)
            
            if let _ = response.result.error
            {
                responseData(nil, response.result.error as NSError?, MESSAGE)
            }
            else
            {
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value
                    {
                        self.resObjects = (data as! NSArray) as AnyObject
                        responseData(self.resObjects, nil, self.Message)
                    }
                    break
                    
                case .failure(_):
                    responseData(nil, response.result.error as NSError?, MESSAGE)
                    break
                    
                }
            }
        }
        
    }
    
    
    //MARK:- PUT Request
    func putRequest(endpointurl:String,parameters:NSDictionary,responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        ShowNetworkIndicator(xx: true)
        
        alamoFireManager.request(endpointurl, method: .post, parameters: parameters as? Parameters).responseJSON { (response:DataResponse<Any>) in
            self.ShowNetworkIndicator(xx: false)
            if let _ = response.result.error
            {
                responseData(nil, response.result.error as NSError?, MESSAGE)
            }
            else
            {
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value
                    {
                        self.Message = (data as! NSDictionary)[WSMESSAGE].asStringOrEmpty()
                        let responseStatus = (data as! NSDictionary)[WSSTATUS].aIntOrEmpty()
                        switch (responseStatus) {
                            
                        case RESPONSE_STATUS.VALID.rawValue :
                            self.resObjects = (data as! NSDictionary) as AnyObject
                            break
                            
                        case RESPONSE_STATUS.INVALID.rawValue :
                            self.resObjects = nil
                            break
                            
                        default :
                            break
                        }
                        responseData(self.resObjects, nil, self.Message)
                    }
                    break
                    
                case .failure(_):
                    responseData(nil, response.result.error as NSError?, MESSAGE)
                    break
                    
                }
            }
        }
    }

    //MARK:- Cancel Request
    func cancelAllAlamofireRequests(responseData:@escaping ( _ status: Bool?) -> Void)
    {
       alamoFireManager.session.getTasksWithCompletionHandler
            {
                dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
                responseData(true)
        }
    }
    
    //MARK: - Method to postMultipartJSONRequest
    func postMultipartJSONRequest(endpointurl:String, parameters:NSDictionary, encodingType:ParameterEncoding = JSONEncoding.default, responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        ShowNetworkIndicator(xx: true)
        
        alamoFireManager.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                if value is UIImage {
                    let imageData:Data = (value as! UIImage).jpegData(compressionQuality: 0.3)!//UIImageJPEGRepresentation(value as! UIImage, 0.3)!
                    multipartFormData.append(imageData, withName: key as! String, fileName: "swift_file.jpg", mimeType: "image/*")
                }else if value is NSURL || value is URL {
                    let videoData:Data
                    do {
                        videoData = try Data (contentsOf: (value as! URL), options: .mappedIfSafe)
                        let extenstion = (value as! URL).absoluteString
                        if extenstion.contains(".m4a") {
                            multipartFormData.append(videoData, withName: key as! String, fileName: "swift_file.m4a", mimeType: "audio/*")
                        }else if extenstion.contains(".pdf") {
                            multipartFormData.append(videoData, withName: key as! String, fileName: "swift_file.pdf", mimeType: "file/*")
                        }else {
                            multipartFormData.append(videoData, withName: key as! String, fileName: "swift_file.mp4", mimeType: "video/*")
                        }
                        
                    } catch {
                        print(error)
                        return
                    }
                }else if value is NSArray || value is NSMutableArray {
                    for childValue in value as! NSArray
                    {
                        if childValue is UIImage {
                            //'UIImageJPEGRepresentation' has been replaced by instance method 'UIImage.jpegData(compressionQuality:)'
                            let imageData:Data = (childValue as! UIImage).jpegData(compressionQuality: 0.3)!//UIImageJPEGRepresentation(childValue as! UIImage, 0.3)!
                            multipartFormData.append(imageData, withName: key as! String, fileName: "swift_file.jpg", mimeType: "image/*")
                        }else if childValue is NSURL || childValue is URL {
                            let videoData:Data
                            do {
                                videoData = try Data (contentsOf: (childValue as! URL), options: .mappedIfSafe)
                                let extenstion = (childValue as! URL).absoluteString
                                if extenstion.contains(".m4a") {
                                    multipartFormData.append(videoData, withName: key as! String, fileName: "swift_file.m4a", mimeType: "audio/*")
                                }else {
                                    multipartFormData.append(videoData, withName: key as! String, fileName: "swift_file.mp4", mimeType: "video/*")
                                }
                            } catch {
                                print(error)
                                return
                            }
                        }
                    }
                }else {
                    let valueData:Data = ("\(value)" as NSString).data(using: String.Encoding.utf8.rawValue)!
                    multipartFormData.append(valueData, withName: key as! String)
                }
            }
            
        }, to: endpointurl, headers: nil) { encodingResult in
            
            self.ShowNetworkIndicator(xx: false)
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    self.delegate?.didReceivedProgress(progress: Float(progress.fractionCompleted))
                   // showWithStatusDownload(value:Float((progress.fractionCompleted)*100))
                    print(Float(progress.fractionCompleted)*100)
                    
                })
                
                upload.responseString(completionHandler: { (resp) in
                    //print("RESP : \(resp)")
                })
                
                upload.responseJSON { response in
                    ////print(response)
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value
                        {
                            self.Message = (data as! NSDictionary)[WSMESSAGE].asStringOrEmpty()
                            let responseStatus = (data as! NSDictionary)[WSSTATUS].asStringOrEmpty()
                            switch (responseStatus) {
                                
                            case "success"/*RESPONSE_STATUS.VALID.rawValue*/ :
                                self.resObjects = (data as! NSDictionary) as AnyObject
                                break
                                
                            case "failed"/*RESPONSE_STATUS.INVALID.rawValue*/ :
                                self.resObjects = nil
                                break
                                
                            default :
                                break
                            }
                            responseData(self.resObjects, nil, self.Message)
                        }
                        break
                        
                    case .failure(_):
                        responseData(nil, response.result.error as NSError?,MESSAGE)
                        break
                        
                    }
                }
            case .failure( _):
                responseData(nil, nil, MESSAGE)
            }
        }
    }
    public func ShowNetworkIndicator(xx :Bool)
    {
        DispatchQueue.main.async
            {
                UIApplication.shared.isNetworkActivityIndicatorVisible = xx
        }
        
    }
}

public func ShowNetworkIndicator(xx :Bool)
{
    UIApplication.shared.isNetworkActivityIndicatorVisible = xx
}

public func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        completion(data, response, error)
        }.resume()
}

