//
//  allbeat.swift
//  allbeat
//
//  Created by Tim Lupo on 8/8/16.
//  Copyright © 2016 Allbeat. All rights reserved.
//
import Foundation
import Firebase

open class Allbeat {
    
    fileprivate static let database = FIRDatabase.database().reference()
    fileprivate static let http = "http://allbeatserver.nnyuzdwruw.us-east-1.elasticbeanstalk.com"
    fileprivate static let key = "o1DNrmDNKlqqElIJGU2Y"
    fileprivate static let storage = FIRStorage.storage()
    fileprivate static let storageRef = storage.reference(forURL: "gs://allbeat-d6aaa.appspot.com")
    
    /* AUTH */
    
    static func createUserEmail(useremail: String, userpassword: String, username: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        FIRAuth.auth()?.createUser(withEmail: useremail, password: userpassword) { (user, error) in
            if (error != nil) {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("createUserEmail - EXCEPTION (auth): invalid email")
                    case .errorCodeEmailAlreadyInUse:
                        print("createUserEmail - EXCEPTION (auth): email already taken")
                    case .errorCodeWeakPassword:
                        print("createUserEmail - EXCEPTION (auth): password too weak")
                    default:
                        print("createUserEmail - EXCEPTION (auth): \(error) // please try again")
                    }
                    completionBlock(false)
                }
            } else {
                self.database.child("users").updateChildValues(["\(FIRAuth.auth()!.currentUser!.uid)":["email":useremail, "username":username, "artist":false, "verified":false, "followingCount":0, "followerCount":0]]) { (error, ref) in
                    if error != nil {
                        print("createUserByEmail - EXCEPTION (database): \(error) //please try again")
                        completionBlock(false)
                    } else {
                        print("createUserByEmail - success")
                        completionBlock(true)
                    }
                }
            }
        }
    }
    
    //create user facebook https://firebase.google.com/docs/auth/ios/facebook-login
    
    static func loginUserEmail(useremail: String, userpassword: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        FIRAuth.auth()?.signIn(withEmail: useremail, password: userpassword) { (user, error) in
            if (error != nil) {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeUserNotFound:
                        print("loginUserEmail - EXCEPTION: user not found")
                    case .errorCodeWrongPassword:
                        print("loginUserEmail - EXCEPTION: wrong password")
                    default:
                        print("loginUserEmail - EXCEPTION: \(error) // please try again")
                    }
                    completionBlock(false)
                }
            } else {
                print("loginUserEmail - success")
                completionBlock(true)
            }
        }
    }
    
    static func getCurrentUser() -> FIRUser {
        if ((FIRAuth.auth()?.currentUser) == nil) {
            print("EXCEPTION: no current account")
        }
        return (FIRAuth.auth()?.currentUser)!
    }
    
    static func isLoggedIn() -> Bool {
        if (FIRAuth.auth()?.currentUser) != nil {
            return true
        } else {
            return false
        }
    }
    
    static func logout(completionBlock : @escaping ((_ data : Bool)-> Void)) {
        do {
            try FIRAuth.auth()!.signOut()
            completionBlock(true)
        } catch {
            print("logout - EXCEPTION: logout failed // please try again")
            completionBlock(false)
        }
    }
    
    static func reAuthUser(user: FIRUser, credential: FIRAuthCredential, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        user.reauthenticate(with: credential) { error in
            if error != nil {
                print("reAuthUser - EXCEPTION: \(error) // please try again")
                completionBlock(false)
            } else {
                print("reAuthUser - success")
                completionBlock(true)
            }
        }
    }
    
    /* USER */
    
    static func setUserEmail(user: FIRUser, email: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        user.updateEmail(email) { error in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("setUserEmail - EXCEPTION (auth): invalid email")
                    case .errorCodeEmailAlreadyInUse:
                        print("setUserEmail - EXCEPTION (auth): email already taken")
                    default:
                        print("setUserEmail - EXCEPTION (auth): \(error) // please try again")
                    }
                    completionBlock(false)
                }
            } else {
                self.database.child("users/"+(user.uid)+"/").updateChildValues(["email":email]) { (error, ref) in
                    if error != nil {
                        print("setUserEmail - EXCEPTION (database): \(error) //please try again")
                        completionBlock(false)
                    } else {
                        print("setUserEmail - success")
                        completionBlock(true)
                    }
                }
            }
        }
    }
    
    static func setUserPassword(user: FIRUser, password: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        user.updatePassword(password) { error in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeWeakPassword:
                        print("setUserPassword - EXCEPTION: password too weak")
                    default:
                        print("setUserPassword - EXCEPTION: \(error) // please try again")
                    }
                    completionBlock(false)
                }
            } else {
                print("setUserPassword - success")
                completionBlock(true)
            }
        }
    }
    
    static func setUserName(user: FIRUser, name: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if error != nil {
                print("setUserName - EXCEPTION (auth): \(error) // please try again")
                completionBlock(false)
            } else {
                self.database.child("users/"+(user.uid)+"/").updateChildValues(["username":name]) { (error, ref) in
                    if error != nil {
                        print("setUserName - EXCEPTION (database): \(error) //please try again")
                        completionBlock(false)
                    } else {
                        print("setUserName - success")
                        completionBlock(true)
                    }
                }
            }
        }
    }
    
    static func setUserDisplayName(user: FIRUser, bio: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        self.database.child("users/"+(user.uid)+"/").updateChildValues(["displayName":bio]) { (error, ref) in
            if error != nil {
                print("setUserDisplayName - EXCEPTION: \(error) //please try again")
                completionBlock(false)
            } else {
                print("setUserDisplayName - success")
                completionBlock(true)
            }
        }
    }
    
    /*
     LATER IMPLEMENTATION - DO NOT TOUCH
     
     static func setUserProPic(user: FIRUser, image: UIImage!,  completionBlock : @escaping ((_ data : Bool)-> Void)) {
     let data: Data = UIImageJPEGRepresentation(image!, 0.8)!
     let imgPath = user.uid+"/propic/propic.jpg"
     let imgRef = storageRef.child(imgPath)
     let meta = FIRStorageMetadata()
     meta.contentType = "image/jpeg"
     imgRef.put(data, metadata: meta) { (metaData, error) in
     if error == nil {
     let url = metaData!.downloadURL()!.absoluteString
     let changeRequest = user.profileChangeRequest()
     changeRequest.photoURL = URL(string: url)
     changeRequest.commitChanges { error in
     if error != nil {
     print("setUserProPic - EXCEPTION (auth): \(error) //please try again")
     completionBlock(false)
     } else {
     self.database.child("users/"+(user.uid)+"/").updateChildValues(["propicURL":url]) { (error, ref) in
     if error != nil {
     print("setUserProPic - EXCEPTION (database): \(error) //please try again")
     completionBlock(false)
     } else {
     print("setUserProPic - success")
     completionBlock(true)
     }
     }
     }
     }
     } else {
     print("setUserProPic - EXCEPTION (storage): \(error) //please try again")
     completionBlock(false)
     }
     }
     }
     */
    
    static func setUserBio(user: FIRUser, bio: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        self.database.child("users/"+(user.uid)+"/").updateChildValues(["bio":bio]) { (error, ref) in
            if error != nil {
                print("setUserBio - EXCEPTION: \(error) //please try again")
                completionBlock(false)
            } else {
                print("setUserBio - success")
                completionBlock(true)
            }
        }
    }
    
    static func setUserArtist(user: FIRUser, isArtist: Bool, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        self.database.child("users/"+(user.uid)+"/").updateChildValues(["artist":isArtist]) { (error, ref) in
            if error != nil {
                print("setArtist - EXCEPTION: \(error) //please try again")
                completionBlock(false)
            } else {
                print("setArtist - success")
                completionBlock(true)
            }
        }
    }
    
    static func setUserVerified(user: FIRUser, isVerified: Bool, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        self.database.child("users/"+(user.uid)+"/").updateChildValues(["verified":isVerified]) { (error, ref) in
            if error != nil {
                print("setVerified - EXCEPTION: \(error) //please try again")
                completionBlock(false)
            } else {
                print("setVerified - success")
                completionBlock(true)
            }
        }
    }
    
    static func deleteUser(user: FIRUser, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        user.delete { error in
            if error != nil {
                print("deleteUser - EXCEPTION (auth): \(error) // please try again")
                completionBlock(false)
            } else {
                self.database.child("users/"+(user.uid)).removeValue { (error, ref) in
                    if error != nil {
                        print("deleteUser - EXCEPTION (database): \(error) //please try again")
                        completionBlock(false)
                    } else {
                        print("deleteUser - success")
                        completionBlock(true)
                    }
                }
            }
        }
    }
    
    static func getUserID(user: FIRUser) -> String {
        return user.uid
    }
    
    static func getUserName(userID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbString = (snapshot.value as? NSDictionary)?["username"] as? String ?? nil
            completionBlock(dbString)
        }) { (error) in
            print("getUserName - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getUserEmail(userID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbString = (snapshot.value as? NSDictionary)?["email"] as? String ?? nil
            completionBlock(dbString)
        }) { (error) in
            print("getUserName - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getUserDisplayName(userID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbString = (snapshot.value as? NSDictionary)?["displayName"] as? String ?? nil
            completionBlock(dbString)
        }) { (error) in
            print("getUserDisplayName - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getUserProPic(userID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbString = (snapshot.value as? NSDictionary)?["propicURL"] as? String ?? nil
            completionBlock(dbString)
        }) { (error) in
            print("getUserProPic - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getUserBio(userID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbString = (snapshot.value as? NSDictionary)?["bio"] as? String ?? nil
            completionBlock(dbString)
        }) { (error) in
            print("getUserBio - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getUserVerified(channelID: String, completionBlock : @escaping ((_ data : Bool?)-> Void)) {
        self.database.child("users").child(channelID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbBool = (snapshot.value as? NSDictionary)?["verified"] as? Bool ?? nil
            completionBlock(dbBool)
        }) { (error) in
            print("getUserVerified - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func isUserEmailVerified(user: FIRUser) -> Bool {
        return user.isEmailVerified
    }
    
    static func isUserArtist(userID: String, completionBlock : @escaping ((_ data : Bool?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbBool = (snapshot.value as? NSDictionary)?["artist"] as? Bool ?? nil
            completionBlock(dbBool)
        }) { (error) in
            print("isArtist - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func aggregatePosts(userID: String, num: Int, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/aggregate/posts?key=" + key + "&uid=" + userID + "&num=" + String(num)
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("aggregatePosts - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("aggregatePosts - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("aggregatePosts - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("aggregatePosts - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("aggregatePosts - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func aggregateNotifications(userID: String, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/aggregate/notifications?key=" + key + "&uid=" + userID
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("aggregateNotifications - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("aggregateNotifications - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("aggregateNotifications - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("aggregateNotifications - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("aggregateNotifications - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func getNotification(userID: String, notifID: String, completionBlock : @escaping ((_ data : NSDictionary?)-> Void)) {
        let url = http+"/getNotification?key=" + key + "&uid=" + userID + "&notifID=" + notifID
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? NSDictionary {
                            completionBlock(results)
                        } else {
                            print("getNotification - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("getNotification - EXCEPTION: json responded with error")
                        completionBlock(nil)
                    }
                } else {
                    print("getNotification - EXCEPTION: could not find json result")
                    completionBlock(nil)
                }
            } else {
                print("getNotification - EXCEPTION: received data is nil")
                completionBlock(nil)
            }
        }
    }
    
    static func removeNotification(userID: String, notifID: String, completionBlock : @escaping ((_ data : Bool?)-> Void)) {
        let url = http+"/action/removeNotification"
        let post = "key="+key+"&uid="+userID+"&notifID="+notifID
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("removeNotification - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("removeNotification - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("removeNotification - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("removeNotification - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("removeNotification - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("removeNotification - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    /* FOLLOWING AND FOLLOWING */
    
    static func follow(userID: String, userID2: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let url = http+"/action/follow"
        let post = "key="+key+"&uid="+userID+"&uid2="+userID2
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("follow - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("follow - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("follow - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("follow - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("follow - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("follow - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    
    static func unfollow(userID: String, userID2: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let url = http+"/action/unfollow"
        let post = "key="+key+"&uid="+userID+"&uid2="+userID2
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("unfollow - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("unfollow - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("unfollow - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("unfollow - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("unfollow - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("unfollow - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    
    static func getFollowing(userID: String, num: Int, completionBlock : @escaping ((_ following : Array<String>?)-> Void)) {
        let url = http+"/aggregate/following?key="+key+"&uid="+userID+"&num="+String(num)
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("aggregateFollowing - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("aggregateFollowing - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("aggregateFollowing - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("aggregateFollowing - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("aggregateFollowing - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func getFollowers(userID: String, num: Int, completionBlock : @escaping ((_ following : Array<String>?)-> Void)) {
        let url = http+"/aggregate/followers?key="+key+"&uid="+userID+"&num="+String(num)
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("getFollowers - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("getFollowers - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("getFollowers - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("getFollowing - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("getFollowing - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func getFollowers(userID: String, completionBlock : @escaping ((_ following : NSDictionary?)-> Void)) {
        self.database.child("users").child(userID).child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary) ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getFollowers - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getNumFollowing(userID: String, completionBlock : @escaping ((_ numFollowing : Int?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbInt = (snapshot.value as? NSDictionary)?["followingCount"] as? Int ?? nil
            completionBlock(dbInt)
        }) { (error) in
            print("getNumFollowing - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getNumFollowers(userID: String, completionBlock : @escaping ((_ numFollowing : Int?)-> Void)) {
        self.database.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbInt = (snapshot.value as? NSDictionary)?["followerCount"] as? Int ?? nil
            completionBlock(dbInt)
        }) { (error) in
            print("getNumFollowers - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    /* ACTIONS */
    
    static func getFeed(userID: String, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/feed?uid=" + userID + "&key=" + key
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? [[String: AnyObject]] {
                            var ids: Array<String> = []
                            var count: Int = 0
                            for result in results {
                                if let id = result["trackID"] as? String {
                                    ids.append(id)
                                    count += 1
                                } else {
                                    print("getFeed - EXCEPTION: could not parse 'trackID'")
                                    completionBlock(nil)
                                }
                            }
                            print("getFeed - success (" + String(count) + " results found)")
                            completionBlock(ids)
                        } else {
                            print("getFeed - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("getFeed - EXCEPTION: json responded with error")
                        completionBlock(nil)
                    }
                } else {
                    print("getFeed - EXCEPTION: could not find json result")
                    completionBlock(nil)
                }
            } else {
                print("getFeed - EXCEPTION: received data is nil")
                completionBlock(nil)
            }
        }
    }
    
    static func searchUsers(_ query: String, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        //replace all spaces with '%20'
        let replaced = (query as NSString).replacingOccurrences(of: " ", with: "%20")
        let replaced2 = (replaced as NSString).replacingOccurrences(of: "/", with: "%2F")
        //let replaced = query.replacingOccurrences(of:" ", with: "%20")
        //let replaced2 = replaced.replacingOccurrences(of:"/", with: "%2F")
        let url = http+"/searchUser?key=" + key + "&query=" + replaced2
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("searchUsers - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("searchUsers - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("searchUsers - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("searchUsers - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("searchUsers - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func searchTracks(_ query: String, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let replaced = (query as NSString).replacingOccurrences(of: " ", with: "%20")
        let replaced2 = (replaced as NSString).replacingOccurrences(of: "/", with: "%2F")
        //let replaced = query.replacingOccurrences(of:" ", with: "%20")
        //let replaced2 = replaced.replacingOccurrences(of:"/", with: "%2F")
        let url = http+"/searchTitle?key=" + key + "&query=" + replaced2
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? [[String: AnyObject]] {
                            var ids: Array<String> = []
                            var count: Int = 0
                            for result in results {
                                if let id = result["trackID"] as? String {
                                    ids.append(id)
                                    count += 1
                                } else {
                                    print("searchTracks - EXCEPTION: could not parse 'trackID'")
                                    completionBlock(nil)
                                }
                            }
                            print("searchTracks - success (" + String(count) + " results found)")
                            completionBlock(ids)
                        } else {
                            print("searchTracks - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("searchTracks - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("searchTracks - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("searchTracks - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func like(userID: String, trackID: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let url = http+"/action/like"
        let post = "uid="+userID+"&key="+key+"&trackID="+trackID
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("like - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("like - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("like - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("like - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("like - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("like - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    
    static func unlike(userID: String, trackID: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let url = http+"/action/unlike"
        let post = "uid="+userID+"&key="+key+"&trackID="+trackID
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("unlike - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("unlike - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("unlike - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("unlike - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("unlike - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("unlike - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    
    static func getNumTrackLikes(trackID: String, completionBlock : @escaping ((_ data : Int?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["likeCount"] as? Int ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getNumLikes - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getArtistArt(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["artistArtURL"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getArtistArt - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func aggregateUserLikes(userID: String, num: Int, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/aggregate/userlikes?key=" + key + "&uid=" + userID + "&num=" + String(num)
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("aggregateUserLikes - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("aggregateUserLikes - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("aggregateUserLikes - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("aggregateUserLikes - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("aggregateUserLikes - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    /*
     LATER IMPLEMENTATION - DO NOT TOUCH
     
     static func aggregateTrackLikes(trackID: String, num: Int, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
     let url = http+"/aggregate/tracklikes?key=" + key + "&trackID=" + trackID + "&num=" + String(num)
     httpGet(url) { (data: NSDictionary?) in
     if (data != nil) {
     if let jsonResult = data?["result"] as? String {
     if (jsonResult == "success") {
     if let results = data?["data"] as? Array<String> {
     print("aggregateTrackLikes - success (" + String(results.count) + " results found)")
     completionBlock(results)
     } else {
     print("aggregateTrackLikes - EXCEPTION: could not parse 'data'")
     completionBlock(nil)
     }
     } else {
     print("aggregateTrackLikes - EXCEPTION: received data is nil")
     completionBlock(nil)
     }
     } else {
     print("aggregateTrackLikes - EXCEPTION: json responded with error")
     completionBlock(nil)
     }
     } else {
     print("aggregateTrackLikes - EXCEPTION: could not find json result")
     completionBlock(nil)
     }
     }
     }
     */
    
    static func rebeat(userID: String, trackID: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let url = http+"/action/rebeat"
        let post = "uid="+userID+"&key="+key+"&trackID="+trackID
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("rebeat - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("rebeat - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("rebeat - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("rebeat - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("rebeat - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("rebeat - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    
    static func unrebeat(userID: String, trackID: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let url = http+"/action/unrebeat"
        let post = "uid="+userID+"&key="+key+"&trackID="+trackID
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("unrebeat - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("unrebeat - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("unrebeat - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("unrebeat - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("unrebeat - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("unrebeat - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    
    static func hasUserLiked(userID: String, trackID: String, completionBlock: @escaping ((_ data : Bool?)-> Void)) {
        let url = http+"/hasUserLiked"+"?uid="+userID+"&trackID="+trackID+"&key="+key
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["message"] as? String {
                            print("hasUserLiked - success")
                            completionBlock(results=="true")
                        } else {
                            print("hasUserLiked - EXCEPTION: could not parse message")
                            completionBlock(nil)
                        }
                    } else {
                        print("hasUserLiked - EXCEPTION: json responded with error")
                        completionBlock(nil)
                    }
                } else {
                    print("hasUserLiked - EXCEPTION: Could not read result")
                    completionBlock(nil)
                }
            } else {
                print("hasUserLiked - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func hasUserRebeated(userID: String, trackID: String, completionBlock: @escaping ((_ data : Bool?)-> Void)) {
        let url = http+"/hasUserRebeated"+"?uid="+userID+"&trackID="+trackID+"&key="+key
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["message"] as? String {
                            print("hasUserRebeated - success")
                            completionBlock(results=="true")
                        } else {
                            print("hasUserRebeated - EXCEPTION: could not parse message")
                            completionBlock(nil)
                        }
                    } else {
                        print("hasUserRebeated - EXCEPTION: json responded with error")
                        completionBlock(nil)
                    }
                } else {
                    print("hasUserRebeated - EXCEPTION: Could not read result")
                    completionBlock(nil)
                }
            } else {
                print("hasUserRebeated - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func getNumRebeats(trackID: String, completionBlock : @escaping ((_ data : Int?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["rebeatCount"] as? Int ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getNumRebeats - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func aggregateUserRebeats(userID: String, num: Int, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/aggregate/userrebeats?key=" + key + "&uid=" + userID + "&num=" + String(num)
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("aggregateUserRebeats - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("aggregateUserRebeats - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("aggregateUserRebeats - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("aggregateUserRebeats - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("aggregateUserRebeats - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    /*
     LATER IMPLEMENTATION - DO NOT TOUCH
     
     static func aggregateTrackRebeats(trackID: String, num: Int, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
     let url = http+"/aggregate/trackrebeats?key=" + key + "&trackID=" + trackID + "&num=" + String(num)
     httpGet(url) { (data: NSDictionary?) in
     if (data != nil) {
     if let jsonResult = data?["result"] as? String {
     if (jsonResult == "success") {
     if let results = data?["data"] as? Array<String> {
     print("aggregateTrackRebeats - success (" + String(results.count) + " results found)")
     completionBlock(results)
     } else {
     print("aggregateTrackRebeats - EXCEPTION: could not parse 'data'")
     completionBlock(nil)
     }
     } else {
     print("aggregateTrackRebeats - EXCEPTION: received data is nil")
     completionBlock(nil)
     }
     } else {
     print("aggregateTrackRebeats - EXCEPTION: json responded with error")
     completionBlock(nil)
     }
     } else {
     print("aggregateTrackRebeats - EXCEPTION: could not find json result")
     completionBlock(nil)
     }
     }
     }
     */
    
    static func comment(userID: String, trackID: String, comment: String, completionBlock : @escaping ((_ data : NSDictionary?)-> Void)) {
        let url = http+"/action/comment"
        let post = "uid="+userID+"&key="+key+"&trackID="+trackID+"&text="+comment
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("comment - success with message '" + jsonMessage + "'")
                            completionBlock(data)
                        } else {
                            print("comment - success with invalid message code")
                            completionBlock(data)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("comment - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(data)
                        } else {
                            print("comment - EXCEPTION: action failed with invalid message code")
                            completionBlock(data)
                        }
                    }
                } else {
                    print("comment - EXCEPTION: could not parse 'result'")
                    completionBlock(data)
                }
            } else {
                print("comment - EXCEPTION: received data is nil")
                completionBlock(nil)
            }
        }
    }
    
    static func uncomment(userID: String, trackID: String, commentID: String, completionBlock : @escaping ((_ data : Bool)-> Void)) {
        let url = http+"/action/uncomment"
        let post = "uid="+userID+"&key="+key+"&trackID="+trackID+"&commentID="+commentID
        httpPost(url, post) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let jsonMessage = data?["message"] as? String {
                            print("uncomment - success with message '" + jsonMessage + "'")
                            completionBlock(true)
                        } else {
                            print("uncomment - success with invalid message code")
                            completionBlock(true)
                        }
                    } else {
                        if let jsonMessage = data?["message"] as? String {
                            print("uncomment - EXCEPTION: action failed with message '" + jsonMessage + "'")
                            completionBlock(false)
                        } else {
                            print("uncomment - EXCEPTION: action failed with invalid message code")
                            completionBlock(false)
                        }
                    }
                } else {
                    print("uncomment - EXCEPTION: could not parse 'result'")
                    completionBlock(false)
                }
            } else {
                print("uncomment - EXCEPTION: received data is nil")
                completionBlock(false)
            }
        }
    }
    
    static func aggregateComments(trackID: String, num: Int, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/aggregate/comments?key=" + key + "&trackID=" + trackID + "&num=" + String(num)
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let jsonResult = data?["result"] as? String {
                    if (jsonResult == "success") {
                        if let results = data?["data"] as? Array<String> {
                            print("aggregateComments - success (" + String(results.count) + " results found)")
                            completionBlock(results)
                        } else {
                            print("aggregateComments - EXCEPTION: could not parse 'data'")
                            completionBlock(nil)
                        }
                    } else {
                        print("aggregateComments - EXCEPTION: received data is nil")
                        completionBlock(nil)
                    }
                } else {
                    print("aggregateComments - EXCEPTION: json responded with error")
                    completionBlock(nil)
                }
            } else {
                print("aggregateComments - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func getCommentText(trackID: String, commentID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).child("comments").child(commentID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["comment"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getCommentText - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getCommentUser(trackID: String, commentID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).child("comments").child(commentID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["uid"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getCommentUser - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getCommentTime(trackID: String, commentID: String, completionBlock : @escaping ((_ data : Int?)-> Void)) {
        self.database.child("tracks").child(trackID).child("comments").child(commentID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["timeStamp"] as? Int ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getCommentTime - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    /* CHANNELS */
    
    //setters too lol
    
    static func aggregateChannels(completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/channels?key=" + key
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let results = data?["channels"] as? Array<String> {
                    print("aggregateChannels - success (" + String(results.count) + " results found)")
                    completionBlock(results);
                } else {
                    print("aggregateChannels - EXCEPTION: could not parse 'data'")
                    completionBlock(nil)
                }
            } else {
                print("aggregateChannels - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    static func getChannelTracks(channelID: String, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
        let url = http+"/channels/"+channelID+"?key=" + key
        httpGet(url) { (data: NSDictionary?) in
            if (data != nil) {
                if let results = data?["data"] as? Array<String> {
                    print("getChannelTracks - success (" + String(results.count) + " results found)")
                    var numResults: Int
                    if (results.count > 49) {
                        numResults = 49
                    } else {
                        numResults = results.count
                    }
                    var finalResults: Array<String> = []
                    for i in 0...numResults {
                        finalResults.append(results[i])
                    }
                    completionBlock(finalResults);
                } else {
                    print("getChannelTracks - EXCEPTION: could not parse 'data'")
                    completionBlock(nil)
                }
            } else {
                print("getChannelTracks - EXCEPTION: could not find json result")
                completionBlock(nil)
            }
        }
    }
    
    /*
     LATER IMPLEMENTATION OF CHANNELS - DO NOT TOUCH
     
     static func getChannelOwner(channelID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
     self.database.child("channels").child(channelID).observeSingleEvent(of: .value, with: { (snapshot) in
     let dbString = (snapshot.value as? NSDictionary)?["owner"] as? String ?? nil
     completionBlock(dbString)
     }) { (error) in
     print("getChannelName - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
     }
     }
     
     static func getChannelName(channelID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
     self.database.child("channels").child(channelID).observeSingleEvent(of: .value, with: { (snapshot) in
     let dbString = (snapshot.value as? NSDictionary)?["name"] as? String ?? nil
     completionBlock(dbString)
     }) { (error) in
     print("getChannelName - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
     }
     }
     
     static func getChannelProPic(channelID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
     self.database.child("channels").child(channelID).observeSingleEvent(of: .value, with: { (snapshot) in
     let dbString = (snapshot.value as? NSDictionary)?["propicURL"] as? String ?? nil
     completionBlock(dbString)
     }) { (error) in
     print("getChannelProPic - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
     }
     }
     
     static func getChannelVerified(channelID: String, completionBlock : @escaping ((_ data : Bool?)-> Void)) {
     self.database.child("channels").child(channelID).observeSingleEvent(of: .value, with: { (snapshot) in
     let dbBool = (snapshot.value as? NSDictionary)?["verified"] as? Bool ?? nil
     completionBlock(dbBool)
     }) { (error) in
     print("getChannelVerified - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
     }
     }
     
     static func getChannelRebeats(userID: String, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
     self.database.child("channels").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
     let dbData = (snapshot.value as? NSDictionary)?["rebeats"] as? Array<String> ?? nil
     completionBlock(dbData)
     }) { (error) in
     print("getChannelRebeats - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
     }
     }
     
     static func getChannelPosts(userID: String, completionBlock : @escaping ((_ data : Array<String>?)-> Void)) {
     self.database.child("channels").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
     let dbData = (snapshot.value as? NSDictionary)?["posts"] as? Array<String> ?? nil
     completionBlock(dbData)
     }) { (error) in
     print("getChannelPosts - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
     }
     }
     */
    
    /* TRACKS */
    
    static func getTrackName(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["name"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getTrackName - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getTrackArtist(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["artist"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getTrackArtist - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getTrackGenre(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["genre"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getTrackGenre - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getTrackURL(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["streamURL"] as? String ?? nil
            print(dbData)
            completionBlock(dbData)
        }) { (error) in
            print("getTrackURL - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getTrackTimeStamp(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["timeStamp"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getTrackTimeStamp - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getTrackDescription(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["description"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getTrackDescription - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func getTrackArt(trackID: String, completionBlock : @escaping ((_ data : String?)-> Void)) {
        self.database.child("tracks").child(trackID).observeSingleEvent(of: .value, with: { (snapshot) in
            let dbData = (snapshot.value as? NSDictionary)?["artworkURL"] as? String ?? nil
            completionBlock(dbData)
        }) { (error) in
            print("getTrackArt - data could not be retrieved - EXCEPTION: " + error.localizedDescription)
        }
    }
    
    static func httpPost(_ httpURL: String,_ postString: String, completionBlock : @escaping ((_ data : NSDictionary?)-> Void)) {
        let req = NSMutableURLRequest(url: URL(string:(httpURL))!)
        req.httpMethod = "POST"
        req.httpBody = postString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            if response == nil {
                print("HTTP POST Error - response not received on request \(httpURL+postString)")
                completionBlock(nil)
            } else if error != nil {
                let httpResponse = response! as! HTTPURLResponse
                print("HTTP POST Error - code \(httpResponse.statusCode) - error received on request \(httpURL+postString) - \(error!.localizedDescription)")
                completionBlock(nil)
            } else if data == nil {
                let httpResponse = response! as! HTTPURLResponse
                print("HTTP POST Error - code \(httpResponse.statusCode) - data not received on request \(httpURL+postString)")
                completionBlock(nil)
            } else {
                let httpResponse = response! as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .allowFragments]) as? NSDictionary
                        if (json != nil) {
                            print("HTTP POST success")
                            completionBlock(json)
                        } else {
                            print("HTTP POST Error - parsed data is nil")
                            completionBlock(nil)
                        }
                    } catch _ {
                        print("HTTP POST Error - could not parse received data")
                        completionBlock(nil)
                    }
                } else {
                    print("HTTP POST Error - successful call with failing response code \(httpResponse.statusCode)")
                    completionBlock(nil)
                }
            }
            }.resume()
    }
    
    fileprivate static func httpGet(_ httpURL: String, completionBlock : @escaping ((_ data : NSDictionary?)-> Void)) {
        let req = NSMutableURLRequest(url: URL(string:(httpURL))!)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            if response == nil {
                print("HTTP GET Error - response not received on request \(httpURL)")
                completionBlock(nil)
            } else if error != nil {
                let httpResponse = response! as! HTTPURLResponse
                print("HTTP GET Error - code \(httpResponse.statusCode) - error received on request \(httpURL) - \(error!.localizedDescription)")
                completionBlock(nil)
            } else if data == nil {
                let httpResponse = response! as! HTTPURLResponse
                print("HTTP GET Error - code \(httpResponse.statusCode) - data not received on request \(httpURL)")
                completionBlock(nil)
            } else {
                let httpResponse = response! as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .allowFragments]) as? NSDictionary
                        if (json != nil) {
                            print("HTTP GET success")
                            completionBlock(json)
                        } else {
                            print("HTTP GET Error - parsed data is nil")
                            completionBlock(nil)
                        }
                    } catch _ {
                        print("HTTP GET Error - could not parse received data")
                        completionBlock(nil)
                    }
                } else {
                    print("HTTP GET Error - successful call with failing response code \(httpResponse.statusCode)")
                    completionBlock(nil)
                }
            }
            }.resume()
    }
    
    /*
     
     ERRORS NOT HANDLED, JUST PRINTS INFO (TO HANDLE MODIFY WHERE RESPECTIVE PRINTS ARE)
     WHEN GETTING A RETURN, ERRORS ARE HANDLED AND IF THERE IS AN ERROR IT RETURNS NIL
     
     TODO FUNCTIONS TO BE IMPLEMENTED:
     
     aggregates
     /channels/channelname
     
     also followers for channels
     
     func getUserVerified
     
     fb login
     
     timestamps?
     
     fancier json parsing?
     - accomodating for nesting, etc
     
     KNOWN BUGS (in progress):
     - createUserByEmail, setUserEmail, and deleteUser if updateChildValues fails user will be created/deleted in auth but database reference won't be made
     - people can have the same username
     
     PROGRESS:
     (..) /feed
     (..) /channels
     (..) /channels/channelID
     (..) /search
     (..) profile/artist
     (..) profile/user
     (..) /aggregate/likes
     (..) /aggregate/rebeats
     (..) /edit/profile
     (..) /login/email
     (..) /register/email
     /login/fb
     /register/fb
     (..) /action/like
     (..) /action/unlike
     (..) /retrieve/likes
     (..) /action/rebeat
     (..) /action/unrebeat
     (..) /retrieve/rebeats
     (..) /action/comment
     (..) /action/uncomment
     (..) /retrieve/comments
     
     Useful GET/POST auth reading: http://swiftdeveloperblog.com/http-get-request-example-in-swift/
     
     */
}
