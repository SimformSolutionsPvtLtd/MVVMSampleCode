//
//  APIManager.swift
//  MVVMCodeSample
//

//
import Foundation

import AFNetworking
import CoreLocation


// we need a custom serializer for AFNetworking to be able to get at response data after an error (particularly for registration errors)
class JobaloJSONResponseSerializer: AFJSONResponseSerializer {
    
    
    
}



public class APIManager {
    
    //service complition block
    typealias ServiceComplitionBlock = ([String : AnyObject]? ,APIResult)  -> Void
    
    // static properties get lazy evaluation and dispatch_once_t for free
    struct Static {
        static let instance = APIManager()
    }
    
    // this is the Swift way to do singletons
    class var apiManager: APIManager {
        return Static.instance
    }
    
    
    // needed for all AFNetworking requests
    let manager =  AFHTTPSessionManager()
    
    // needed for session token persistence
    let userDefaults = UserDefaults.standard
    
    
    init()
    {
        
    }
    func clearSession() {
        
        
    }
    
    func Login(params : [String : AnyObject],loaderText:String , successClosure: @escaping ServiceComplitionBlock) {
        
        self.showLoader(message: loaderText)
        let url = self.makeAppUrl(endpoint: APIConstants.loginEndpoint)
        self.postDatadicFromUrl(url: url, dic: params) { (response, result) -> Void in
            successClosure(response , result)
            self.hideLoader()
        }
    }
    
    func Logout(loaderText:String , successClosure: @escaping ServiceComplitionBlock) {
        
        self.showLoader(message: loaderText)
        let url = self.makeAppUrl(endpoint: APIConstants.logout)
        self.getDatadicFromUrl(url: url, dic: [:]) { (response, result) in
            successClosure(response , result)
            self.hideLoader()
        }
    }

    func getAllMeditation(params:[String : AnyObject],loaderText:String,ShowLoader:Bool,successClosure: @escaping ServiceComplitionBlock){
        if(ShowLoader == true){
            self.showLoader(message: loaderText)
        }
        let url = self.makeAppUrl(endpoint: APIConstants.allMeditation)
        self.getDatadicFromUrl(url: url, dic: params) { (response, result) -> Void in
            successClosure(response , result)
            self.hideLoader()
        }
    }

    //MARK: - POST methods -
    func postDatadicFromUrl(url : String, dic : [String : AnyObject] , block: @escaping ServiceComplitionBlock)
    {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = 30
        
        if (UserManager.sharedInstance.CurrentUser?.result?.userSession?.sessionToken != nil) {
            if let session = UserManager.sharedInstance.CurrentUser?.result?.userSession?.sessionToken {
                manager.requestSerializer.setValue(session, forHTTPHeaderField: "session-token")
            }else{
                manager.requestSerializer.setValue("", forHTTPHeaderField: "session-token")
            }
        }
        manager.post(url, parameters: dic, progress: nil, success: { (sessiondata, result) in
            do {
                let responseDict = try JSONSerialization.jsonObject(with: (result as! NSData) as Data, options: .allowFragments) as! [String : AnyObject]
                let responseHeader = sessiondata.response as! HTTPURLResponse
                if (responseHeader.statusCode == 200) {
                    block(responseDict , APIResult.APISuccess)
                }
                else{
                    block(responseDict , APIResult.APIError)
                }
            } catch let error as NSError {
                print(error)
            }
        }) { (errorSessionData, result) -> Void in
            if let _ : Data = (result as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
            {
                if let  errResponse: String = String(data: ((result as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! Data), encoding: String.Encoding.utf8)
                {
                    let responseHeader = errorSessionData?.response as! HTTPURLResponse
                    
                    if (responseHeader.statusCode == 403) {
                      
                    }
                    
                    NSLog("%@", errResponse)
                    
                    if let dictError = self.convertToDictionary(text: errResponse)
                    {
                        let message:String = dictError["message"]! as! String
                        
                    }
                    
                }
            }
        }
        
        block([:],APIResult.APIError)
        
    }

     //MARK: - GET methods -
    func getDatadicFromUrl(url : String, dic : [String : AnyObject] , block: @escaping ServiceComplitionBlock)
    {
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = 30
        
        if (UserManager.sharedInstance.CurrentUser?.result?.userSession?.sessionToken != nil) {
            
            let session:String =  (UserManager.sharedInstance.CurrentUser?.result?.userSession?.sessionToken!)!
            manager.requestSerializer.setValue(session, forHTTPHeaderField: "session-token")
            
        }
        
        manager.get(url, parameters: dic, progress: nil, success: {(sessionDatatask , responseObject) in
            do {
                let responseDict = try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: .allowFragments) as! [String : AnyObject]
                let responseHeader = sessionDatatask.response as! HTTPURLResponse
                
                if (responseHeader.statusCode ==  200) {
                    
                    block(responseDict , APIResult.APISuccess)
                }
                else {
                    block(responseDict , APIResult.APIError)
                }
 
            } catch {
                print("json error: \(error)")
                
            }
            
        }) { (errorSessionData, result) -> Void in
            
            
            
            if let _ : Data = (result as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
            {
                if let  errResponse: String = String(data: ((result as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! Data), encoding: String.Encoding.utf8)
                {
                    let responseHeader = errorSessionData?.response as! HTTPURLResponse
                    
                    if (responseHeader.statusCode == 403) {
                       
                    }
                    
                    NSLog("%@", errResponse)
                    
                    if let dictError = self.convertToDictionary(text: errResponse)
                    {
                        let message:String = dictError["message"]! as! String
                       // AGPushNoteView.show(withNotificationMessage: message)
                    }
                    
                }
            }
            
            
        }
        
        block([:],APIResult.APIError)
    }

   //MARK: - utility methods -
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func showLoader(message:String)
    {
        DispatchQueue.main.async{
           
        }
    }
    
    func hideLoader()
    {
        
    }
}
