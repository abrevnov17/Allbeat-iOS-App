//
//  AuthenticationViewcontroller
//  allbeat
//
//  Created by Anatoly Brevnov on 2/25/16.
//  Copyright © 2017 allbeat, LLC. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var signUpButton : UIButton!
    @IBOutlet weak var loginButton : UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //formatting the login button (probably want to add a pre-made image later) 
        
        loginButton.sizeThatFits(CGSize(width: signUpButton.frame.width, height: signUpButton.frame.height))
        loginButton.layer.cornerRadius = 3
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
