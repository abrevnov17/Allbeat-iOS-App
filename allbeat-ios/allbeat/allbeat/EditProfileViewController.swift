//
//  EditProfileViewController.swift
//  allbeat
//
//  Created by Ari on 9/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import Firebase
class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let imagePicker = UIImagePickerController()
    var image: URL?
    @IBOutlet var oldPassword: UITextField!
   
    @IBOutlet var password: UITextField!
    @IBOutlet var repeatPassword: UITextField!
    @IBOutlet var display: UITextField!
  
    @IBOutlet var email: UITextField!
    @IBOutlet var newDescription: UITextField!
    
    @IBOutlet var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let user1 = Allbeat.getCurrentUser().uid
        Allbeat.aggregatePosts(userID: user1, num: 100) { (songs) in
            print ("songgggs", songs?.count)
        }
        imagePicker.delegate = self
        self.username.text = ""
        self.password.text = ""
        self.email.text = ""
        self.oldPassword.text = ""
        self.repeatPassword.text = ""
        self.display.text = ""
        self.newDescription.text = ""
        
                     self.oldPassword.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        self.password.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        self.repeatPassword.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        self.display.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        self.newDescription.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        self.email.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        self.username.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        Allbeat.getUserEmail(userID: (Allbeat.getCurrentUser().uid)) { (email) in
            if(email != nil){
                self.email.text = email
            }
        }
        Allbeat.getUserDisplayName(userID: (Allbeat.getCurrentUser().uid)) { (display) in
            if (display != nil){
                
                self.display.text = display
            }
        }
        Allbeat.getUserBio(userID: (Allbeat.getCurrentUser().uid)) { (bio) in
            if(bio != nil){
                self.newDescription.text = bio
            }
        }
        Allbeat.getUserName(userID: (Allbeat.getCurrentUser().uid)) { (username) in
            if(username != nil){
                self.username.text = username
            }
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func change(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
       
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://allbeat-app.appspot.com")
            var data = NSData()
            data = UIImageJPEGRepresentation(image, 0.8)! as NSData
            let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
        
           
            
            storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                   // Allbeat.getUserProPic(user: Allbeat.getCurrentUser(),  completionBlock: { (complete) in
                        //if (complete){
                            //print("yay")
                        //}
                    //})
                }
            }
        })
        
    
        
    }
    @IBAction func logOut(_ sender: AnyObject) {
        Allbeat.logout { (isSuccessful: Bool) in
            //called after database fetch has completed
            print(isSuccessful)
            if isSuccessful{
            self.performSegue(withIdentifier: "logOut", sender: self)
            }
        }
    }
    @IBOutlet var change: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if (info["UIImagePickerControllerOriginalImage"] as? UIImage) != nil {
            //UIImageView.contentMode = .ScaleAspectFit
            //imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
 

    @IBAction func done(_ sender: AnyObject) {
        
         let user1:FIRUser = Allbeat.getCurrentUser()
        if self.username.text! != "" {
            
            Allbeat.setUserName(user: user1, name: self.username.text!) { (error) in
                if (error == false){
                    let alertController = UIAlertController(title: "Uh oh!", message:
                        "user Something went wrong. Please make sure your internet connection is working.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }
        }
        if self.email.text != nil {
            
            Allbeat.setUserEmail(user: user1, email: self.email.text!) { (error) in
                if (error){
                    let alertController = UIAlertController(title: "Uh oh!", message:
                        "email Something went wrong. Please make sure your internet connection is working.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }
        }
        if self.display.text != nil {
            Allbeat.setUserDisplayName(user: Allbeat.getCurrentUser(), bio: self.display.text!, completionBlock: { (complete) in
                print("display: ", complete)
            })
        }
        if (self.newDescription.text != nil){
           Allbeat.setUserBio(user: Allbeat.getCurrentUser(), bio: self.newDescription.text!, completionBlock: { (complete) in
            print("description: ", complete)
           })
        }
    
        var email = ""
        if self.password != nil {
            Allbeat.getUserEmail(userID: (Allbeat.getCurrentUser().uid)) { (emailGet) in
                email = emailGet!
            }
            Allbeat.loginUserEmail(useremail: email, userpassword: self.oldPassword.text!) { (error) in
                if (error){
                    let alertController = UIAlertController(title: "Uh oh!", message:
                        "You have entered the wrong password.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    if (self.password.text == self.repeatPassword.text){
                        Allbeat.setUserPassword(user: user1, password: self.password.text!, completionBlock: { (error) in
                            if (error == false){
                                let alertController = UIAlertController(title: "Uh oh!", message:
                                    "pass Something went wrong. Please make sure your internet connection is working.", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                                
                                self.present(alertController, animated: true, completion: nil)

                            }
                        })
                    }
                    else{
                        let alertController = UIAlertController(title: "Uh oh!", message:
                            "Your passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        
                if self.image != nil {
                   }
        self.navigationController?.popViewController(animated: true)
    }

}
