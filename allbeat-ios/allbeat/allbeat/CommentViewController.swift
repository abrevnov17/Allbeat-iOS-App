//
//  CommentViewController.swift
//  allbeat
//
//  Created by Ari on 8/26/16. Modified by Anatoly Brevnov on 3/16/17.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import Firebase
class CommentViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataSource: UIView!
    @IBOutlet var delegate: UIView!
    var kbHeight: CGFloat!
    var trackID: String?  = ""
    var data:[String] = []
    var names:[String: String] = [:]
    var songComments:[String]=[]
    var comments:[String: String] = [:]
    
    var times:[String: Date] = [:]
    
    @IBOutlet var commentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        // self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        
        Allbeat.aggregateComments(trackID: self.trackID!, num: 100) { (comments) in
            if(comments != nil){
                if ((comments?.count)! > 0){
                    self.songComments = comments!
                    print("alpha:" + (comments?[0])!)
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        
        
        
        
        
        self.commentField.delegate = self
        self.commentField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //   NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func reload() {
        
        print("proposition" + self.trackID!)
        Allbeat.aggregateComments(trackID: self.trackID!, num: 100) { (comments) in
            if(comments != nil){
                if ((comments?.count)! > 0){
                    self.songComments = comments!
                    self.tableView.reloadData()
                    
                }
            }
            else {
                
                print(self.trackID!)
            }
        }
        
        if (self.songComments.count > 0){
            let oldLastCellIndexPath = IndexPath(row: self.songComments.count-1, section: 0)
            self.tableView.scrollToRow(at: oldLastCellIndexPath, at: .bottom, animated: false)
        }
        self.tableView.reloadData()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                kbHeight = keyboardSize.height
                self.animateTextField(up: true)
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(up: false)
    }
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement!)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.songComments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
        if self.songComments.count > 0 {
            Allbeat.getCommentText(trackID: self.trackID!, commentID: self.songComments[indexPath.row], completionBlock: { (comment) in
                if(comment != nil){
                    cell.comment.text = comment
                }
            })
            Allbeat.getCommentUser(trackID: self.trackID!, commentID: self.songComments[indexPath.row], completionBlock: { (user) in
                if(user != nil){
                    Allbeat.getUserName(userID: user!, completionBlock: { (name) in
                        if(name != nil){
                            cell.name.text = name
                        }
                        else{
                            cell.name.text = ""
                        }
                    })
                    
                }
            })
            Allbeat.getCommentTime(trackID: self.trackID!, commentID: self.songComments[indexPath.row], completionBlock: { (time) in
                if(time != nil){
                    let d:Double? = Double(time!)
                    let date = NSDate(timeIntervalSince1970: d!)
                    
                    let dayTimePeriodFormatter = DateFormatter()
                    dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
                    
                    let dateString = dayTimePeriodFormatter.string(from: date as Date)
                    print("time",dateString)
                    cell.time.text = dateString
                }
                else{
                    cell.time.text = ""
                }
            })
          
            
            
            
            // Configure the cell...
            //self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
        
        return cell
    }
    func getDate(date: Date) -> String {
        var finalString:String
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let monthInt = (calendar?.component(NSCalendar.Unit.month, from: date))!
        let yearInt = (calendar?.component(NSCalendar.Unit.year, from: date))!
        let minuteInt = (calendar?.component(NSCalendar.Unit.minute, from: date))!
        let dayInt = (calendar?.component(NSCalendar.Unit.day, from: date))!
        let secondInt = (calendar?.component(NSCalendar.Unit.second, from: date))!
        let hourInt = (calendar?.component(NSCalendar.Unit.hour, from: date))!
        
        let monthIntNow = (calendar?.component(NSCalendar.Unit.month, from: Date()))!
        let yearIntNow = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
        let minuteIntNow = (calendar?.component(NSCalendar.Unit.minute, from: Date()))!
        let dayIntNow = (calendar?.component(NSCalendar.Unit.day, from: Date()))!
        let hourIntNow = (calendar?.component(NSCalendar.Unit.hour, from: Date()))!
        let secondIntNow = (calendar?.component(NSCalendar.Unit.second, from: Date()))!
        if (yearIntNow - yearInt == 0){
            if (monthIntNow - monthInt == 0){
                if (dayIntNow - dayInt == 0){
                    if (hourIntNow - hourInt == 0) {
                        if (minuteIntNow - minuteInt == 0){
                            finalString = String(secondIntNow - secondInt) + " sec"
                            return finalString
                            
                        }
                        else {
                            finalString = String(minuteIntNow - minuteInt) + " min"
                            return finalString
                        }
                    }
                    else {
                        finalString = String(hourIntNow-hourInt) + " hr"
                        return finalString
                    }
                    
                }
                else {
                    finalString = String(dayIntNow-dayInt) + " d"
                    return finalString
                }
                
            }
            else {
                finalString = String(monthIntNow-monthInt) + " mo"
                return finalString
            }
        }
        else {
            finalString = String(yearIntNow-yearInt) + " yr"
            return finalString
        }
        
    }
    @IBAction func Post(_ sender: AnyObject) {
        if ((commentField.text?.characters.count)! > 0){
                    
            Allbeat.comment(userID: (Allbeat.getCurrentUser().uid), trackID: self.trackID!, comment:self.commentField.text! ) { (went) in
                
                print(went)
                self.reload()
                
            }
            
            if (self.songComments.count > 0) {
                let oldLastCellIndexPath = IndexPath(row: self.songComments.count-1, section: 0)
                self.tableView.scrollToRow(at: oldLastCellIndexPath, at: .bottom, animated: false)
            
            
        }
            self.commentField.text = ""
        
        }
        
        
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

extension Date
{
    
    init(dateString:String!) {
        
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let d = dateStringFormatter.date(from: dateString)
        self.init(timeInterval:0, since:d!)
    }
}
