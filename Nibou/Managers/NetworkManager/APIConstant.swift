//
//  Constant.swift
//  FIFGROUP
//
//  Created by Himanshu Goyal on 23/10/18.
//  Copyright © 2018 Spice Labs Pvt Ltd. All rights reserved.
//

import Foundation

//MARK:- API Keys

// Basic

//DEV
//let kClientId                      = "KtqwLc20z1Elb1E2GWPfQSpxQTHg0Cc7H_xM_eYtDMo"
//let kClientSecret                  = "z0fp2Ng0dssdmkM18Dk8JL9PvTY-EczdrVeHjhk7eYk"

//PROD
let kClientId                      = "iNnhZW5zRjo9R67wrCaHEdnP51pvlaImOnpoTJOruek"
let kClientSecret                  = "YUtT7DMonOGRE9TC5rdQX5GOoRIFlkeNpZ4g_fx2ptM"
let kContentTypeKey                = "Content-Type"
let kContentTypeValueKey           = "application/json"
let kAuthorizationKey              = "Authorization"
let kAuthorizationValueKey         = "Basic RklGVXNlcjpGSUZVc2Vy"
let kSomethingWentWrongErrorCode   = 1000
let kInternetErrorCode             = 10001
let kServerTimeOut                 = 1001



let kSignUpAPi                     = "/users"
let kAccessToken                   = "/oauth/token"
let kChangePassword                = "/v1/users/me/password"
let kGetProfile                    = "/v1/users/me"
let kUpdateProfile                 = "/v1/users/me"
let kForgotPassword                = "/v1/users/password/change"
let kGetSurveyList                 = "/v1/expertises"
let kUpdateSurveyList              = "/v1/expertises"
let kSearchExpert                  = "/v1/experts"
let kChatSession                   = "/v1/chat/rooms"
let kChatSendMessage               = "/v1/chat/message/"
let kGetChatHistory                = "/v1/chat/message/"
let kGetPreviousExpert             = "/v1/experts/latest"
let kGetRoomDetails                = "/v1/chat/rooms/"
let kCopyChat                      = "/v1/chat/rooms/"
let kEndChatSession                = "/v1/chat/rooms/"
let kRateAndReview                 = "/v1/reviews"
let kFeedback                      = "/v1/feedbacks"
let kGetExpertProfile              = "/v1/users"
let kGetReviewList                 = "/v1/reviews"
let kSaveDeviceToken               = "/v1/users/me/devises"
let kAddCard                       = "/v1/users/me/card"
let kDeleteCard                    = "/v1/users/me/card/"
let kCardDefault                   = "/v1/users/me/card/%@/default"
let kGetOverallPayment             = "/v1/payments/overall"
let kGetMonthlyPayment             = "/v1/payments/month_total?date="
let kGetMonthPerDayPayment         = "/v1/payments/month_per_day?date="
let kGetDayPayment                 = "/v1/payments/by_day?"
let kGetOverallDay                 = "/v1/payments/overall_by_day?"
let kGetSystemText                 = "/v1/system_texts?code="
let kLogOut                        = "/v1/users/me/set_status"
let kEndConversion                 = "/v1/chat/rooms/"

//DEV
//let kStripePublishableKey          = "pk_test_zQzJZyKFPuHuVouExfOyXRv9005Dmbwf8j"
//let kStripeMerchantIdentifier      = "sk_test_fvvSMuoSFqEJFVQzS5rCQiPH00l0G68J56"

//let kWebSocketURL                  = "wss://api.staging.nibouapp.com/cable"
//var kBaseURL                       = "https://api.staging.nibouapp.com"
//

//Production
let kStripePublishableKey          = "pk_live_fbi50lLvcVzcUazidWXYbJGN00bCDQhRNO"
let kStripeMerchantIdentifier      = "sk_live_QINH0Oz1d1w5G0djAtsJGzZS0010zxjjUj"

let kWebSocketURL                  = "wss://api.nibouapp.com/cable"
var kBaseURL                       = "https://api.nibouapp.com"

