//
//  ViewController.swift
//  MVVMCodeSample
//
//  Created by Tejas Ardeshna on 09/08/17.
//  Copyright © 2017 Tejas Ardeshna. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD
class LoginVC: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: Any) {

        if(self.txtEmail.text!.isEmptyField()) || (self.txtEmail.text?.isValidEmail() == false) || (self.txtEmail.text!.isEmptyField()) || (self.txtEmail.text?.isInValidPassword() == true)
        {
            //TBD: - show alert here for error
            return
        }
        
        self.view.endEditing(true)
        
        self.Login()
    }
    func Login()
    {
        var strDeviceToken:NSString? =  UserDefaults.standard.object(forKey: "DeviceToken") as? NSString
        
        if(strDeviceToken == nil)
        {
            strDeviceToken = ""
        }
        SVProgressHUD.show()
        let strToken = UUID().uuidString
        let params:NSDictionary = ["email":self.txtEmail.text!,"password":self.txtPassword.text!,"device_type":"2","device_id":strToken]
        
        _ = APIManager.apiManager.Login(params: params as! [String : AnyObject],loaderText: "") { (dict, result) in
            
            if(result == APIResult.APISuccess){
                let objUser = Mapper<MUserDetail>().map(JSON: dict!)
                SVProgressHUD.dismiss()
                if(objUser?.result?.user?.isEmailVerified == 1)
                {
                    UserManager.sharedInstance.CurrentUser = objUser
                    UserManager.sharedInstance.saveSharedManager()                    
                   self.performSegue(withIdentifier: "login", sender: self)
                }
                else{
                }
            }
        }
    }

}

