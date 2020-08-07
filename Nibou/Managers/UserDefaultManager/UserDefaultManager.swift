//
//  UserDefaultManager.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

/**
 MARK: - Key Contants
 */

let kLanguage               = "Language"
let kAccessTokenModel       = "AccessTokenModel"
let kSignupModel            = "SignupModel"
let kProfileModel           = "ProfileModel"
let kOfflineData            = "OfflineExpertData"
let kNewMessage             = "NewMessage"
let kChatRoom               = "ChatRoom"

//MARK: - Chat Room Status
/**
 MARK: - Set Chat Room Status
 */
func setChatRoomCreatedFirstTime(bool: Bool){
    kUserDefault.set(bool, forKey: kChatRoom)
    kUserDefault.synchronize()
}

/**
 MARK: - Get Chat Room Status
 - Returns: Chat Room Status
 */
func getChatRoomCreatedFirstTime() -> Bool{
    if let status = kUserDefault.value(forKey: kChatRoom) as? Bool{
        return status
    }else{
        return false
    }
}

//MARK: - Current Language
/**
 MARK: - Set Current Language
 */
func setCurrentLanguage(language: String){
    kUserDefault.set(language, forKey: kLanguage)
    kUserDefault.synchronize()
}

/**
 MARK: - Get Current Language
 - Returns: Language Code
 */
func getCurrentLanguage() -> String{
    if let code = kUserDefault.value(forKey: kLanguage) as? String{
        return code
    }else{
        return ""
    }
}


//MARK: - AccessToken Data
/**
 MARK: - Set AccessToken Data
 */
func setAccessTokenModel(model: LoginModel){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(model) {
        kUserDefault.set(encoded, forKey: kAccessTokenModel)
        kUserDefault.synchronize()
    }
}

/**
 MARK: - Get AccessToken Data
 - Returns: AccessToken Data
 */
func getAccessTokenModel() -> LoginModel{
    if let data = kUserDefault.object(forKey: kAccessTokenModel) as? Data {
        let decoder = JSONDecoder()
        if let model = try? decoder.decode(LoginModel.self, from: data) {
            return model
        }else{
            return LoginModel(accessToken: "", tokenType: "", expiresIn: 0, refreshToken: "", createdAt: 0)
        }
    }else{
        return LoginModel(accessToken: "", tokenType: "", expiresIn: 0, refreshToken: "", createdAt: 0)
    }
}

//MARK: - Signup Data
/**
 MARK: - Set Signup Data
 */
func setSignupModel(model: SignupModel){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(model) {
        kUserDefault.set(encoded, forKey: kSignupModel)
        kUserDefault.synchronize()
    }
}

/**
 MARK: - Get Signup Data
 - Returns: Signup Data
 */
func getSignupModel() -> SignupModel{
    if let data = kUserDefault.object(forKey: kSignupModel) as? Data {
        let decoder = JSONDecoder()
        if let model = try? decoder.decode(SignupModel.self, from: data) {
            return model
        }else{
            return SignupModel(data: SignupDataClass(id: "", type: "", attributes: SignupAttributes(username: "", accountType: 1, createdAt: "", updatedAt: "")))
        }
    }else{
        return SignupModel(data: SignupDataClass(id: "", type: "", attributes: SignupAttributes(username: "", accountType: 1, createdAt: "", updatedAt: "")))
    }
}

//MARK: - Profile Data
/**
 MARK: - Set Profile Data
 */
func setProfileModel(model: ProfileModel){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(model) {
        kUserDefault.set(encoded, forKey: kProfileModel)
        kUserDefault.synchronize()
    }
}

/**
 MARK: - Get Profile Data
 - Returns: Profile Data
 */
func getProfileModel() -> ProfileModel?{
    if let data = kUserDefault.object(forKey: kProfileModel) as? Data {
        let decoder = JSONDecoder()
        if let model = try? decoder.decode(ProfileModel.self, from: data) {
            return model
        }else{
            return nil
        }
    }else{
        return nil
    }
}


//MARK: - Offline and Online Expert
/**
 MARK: - Set Offline/Online Data
 */
func setOfflineData(array: [String]){
    kUserDefault.set(array, forKey: kOfflineData)
    kUserDefault.synchronize()
}

/**
 MARK: - Get Offline/Online Data
 - Returns: Offline/Online Data
 */
func getOfflineData() -> [String]{
    if let data = kUserDefault.object(forKey: kOfflineData) as? [String] {
        return data
    }else{
        return []
    }
}

//MARK: - New Message
/**
 MARK: - Set New Message Data
 */
func setNewMessageData(array: [[String: Any]]){
    kUserDefault.set(array, forKey: kNewMessage)
    kUserDefault.synchronize()
}

/**
 MARK: - Get New Message Data
 - Returns: New Message Data
 */
func getNewMessageData() -> [[String: Any]]{
    if let arrayNewMessage = kUserDefault.object(forKey: kNewMessage) as? [[String: Any]] {
        return arrayNewMessage
    }else{
        return []
    }
}

//MARK: - Clear All Defaults
func clearUserDefault(){
    let userDefault = UserDefaults.standard
    userDefault.removeObject(forKey: kNewMessage)
    userDefault.removeObject(forKey: kChatRoom)
    userDefault.removeObject(forKey: kAccessTokenModel)
    userDefault.removeObject(forKey: kSignupModel)
    userDefault.removeObject(forKey: kProfileModel)
    userDefault.removeObject(forKey: kOfflineData)
    userDefault.removeObject(forKey: kNewMessage)
    userDefault.synchronize()
}
