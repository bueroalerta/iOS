//
//  MAService.swift
//  mala-ios
//
//  Created by 王新宇 on 13/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {
    
    /// Get Verification code
    ///
    /// - Parameters:
    ///   - phone:          Phone number
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func sendSMS(phone: String, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.sendSMS(phone: phone), failureHandler: failureHandler, completion: { json in
            let sent = (json["sent"] as? Bool) ?? false
            completion(sent)
        })
    }
    
    /// Verification the SMS code
    ///
    /// - Parameters:
    ///   - phone:          Phone number
    ///   - code:           Verification code
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func verifySMS(phone: String, code: String, failureHandler: failureHandler? = nil, completion: @escaping (LoginUser?) -> Void) -> Cancellable {
        return self.sendRequest(.verifySMS(phone: phone, code: code), failureHandler: failureHandler, completion: { json in
            guard let verified = json["verified"] as? Bool, verified == true else {
                completion(nil)
                return
            }
            
            if let firstLogin = json["first_login"] as? Bool,
               let accessToken = json["token"] as? String,
               let parentID = json["parent_id"] as? Int,
               let userID = json["user_id"] as? Int,
               let profileID = json["profile_id"] as? Int {
                completion(LoginUser(accessToken: accessToken, userID: userID, parentID: parentID, profileID: profileID, firstLogin: firstLogin, avatarURLString: ""))
            }
            completion(nil)
        })
    }
    
    /// Get user profile info
    ///
    /// - Parameters:
    ///   - id:             Profile id of account
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userProfile(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (ProfileInfo?) -> Void) -> Cancellable {
        return self.sendRequest(.profileInfo(id: id), failureHandler: failureHandler, completion: { json in
            guard let _ = json["id"] else {
                completion(nil)
                return
            }
            if let id = json["id"] as? Int,
               let gender = json["gender"] as? String? {
                completion(ProfileInfo(id: id, gender: gender, avatar: (json["avatar"] as? String) ?? ""))
                return
            }
            completion(nil)
        })
    }
    
    /// Get user parent info
    ///
    /// - Parameters:
    ///   - id:             Parent id of account
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userParents(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (ParentInfo?) -> Void) -> Cancellable {
        return self.sendRequest(.parentInfo(id: id), failureHandler: failureHandler, completion: { json in
            guard let _ = json["id"] else {
                completion(nil)
                return
            }
            
            if let id = json["id"] as? Int,
               let studentName = json["student_name"] as? String?,
               let schoolName = json["student_school_name"] as? String? {
                completion(ParentInfo(id: id, studentName: studentName, schoolName: schoolName))
                return
            }
            completion(nil)
        })
    }
    
    /// Upload user avatar
    ///
    /// - Parameters:
    ///   - imageData:      Data of image
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func uploadAvatar(imageData: Data, failureHandler: failureHandler? = nil, completion: @escaping (Bool?) -> Void) -> Cancellable {
        let id = MalaUserDefaults.profileID.value ?? -1
        return self.sendRequest(.uploadAvatar(data: imageData, profileId: id), failureHandler: failureHandler, completion: { json in
            guard let result = json["done"] as? Bool else {
                completion(nil)
                return
            }
            completion(result)
        })
    }
}
