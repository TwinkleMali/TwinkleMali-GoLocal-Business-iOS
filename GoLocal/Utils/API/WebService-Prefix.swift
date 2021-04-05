//
//  WebService-Prefix.swift
//  GoLocal
//
//  Created by C100-104 on 29/12/20.
//

import Foundation

//Service Type
let GET = "GET"
let POST = "POST"
let MEDIA = "MEDIA"
let PRIVATE_KEY = "kashfk=1gdj1123_asdq283y059==="

let isLive = false
let IS_TESTDATA = 1
//http://clientapp.narola.online/sv/GoLocalFirst/API
//GLFService.php?Service=Register
let LOCAL_SERVER_URL = "https://apps.narola.online:444/pma/hde/data/459815/API"

let LIVE_SERVER_URL = "http://18.223.15.96/src/API"

let SERVER_URL = isLive ?  LIVE_SERVER_URL : LOCAL_SERVER_URL
//let DICTINARY = isLive ? "\(SERVER_URL)campsite" : "\(SERVER_URL)"
let WEBSERVICE_PATH = "\(SERVER_URL)/GLFService.php?Service="

////Header
//var headers = [
//    "Content-Type"  : "application/json",
//    "SecretKey"  : SECRET_KEY,
//    "userAgent"     : "iOS",
//    "IsTestdata" : IS_TEST_DATA
//]
//Header
var headers = [
    "Content-Type"  : "application/json",
    "SecretKey"  : "EcS7Vh5ZKI+oeLDZC514Ws3mhySBrdWzzTRIq2JJGqI=",
    "userAgent"     : "iOS",
    "IsTestdata" : "\(IS_TESTDATA)"
]
//Terms location
let TERMS_LOCATION = "\(SERVER_URL)/Terms/"
let PATH_PP = "\(TERMS_LOCATION)privacy_policy.pdf"
let PATH_TC = "\(TERMS_LOCATION)terms_conditions.pdf"
let PATH_disclaimer = "\(TERMS_LOCATION)disclaimer.pdf"
let PATH_OAUTH = "\(SERVER_URL)/s_oauth.php"
//Services
let APIRefreshToken = "\(WEBSERVICE_PATH)RefreshToken"
let APILogin = "\(WEBSERVICE_PATH)Login"
let APILogout  = "\(WEBSERVICE_PATH)Logout"

let APIForgotPassword = "\(WEBSERVICE_PATH)ForgotPassword"
let APIChangePassword = "\(WEBSERVICE_PATH)ChangePassword"
let APIGetAllCountries = "\(WEBSERVICE_PATH)GetAllCountries"
let APIGetSingleUserDetail = "\(WEBSERVICE_PATH)GetSingleUserDetail"
let APIEditUserProfile = "\(WEBSERVICE_PATH)EditUserProfile"
let APIGetNotifications = "\(WEBSERVICE_PATH)GetNotifications"
let APIGetRatingReview = "\(WEBSERVICE_PATH)GetRatingReview"
let APIReplyToRatingReview = "\(WEBSERVICE_PATH)ReplyToRatingReview"
let APIEditBusinessDetails = "\(WEBSERVICE_PATH)EditBusinessDetails"
let APIGetSingleStoreDetail = "\(WEBSERVICE_PATH)GetSingleStoreDetail"
let APIGetMultiOrderDetail = "\(WEBSERVICE_PATH)GetMultiOrderDetail"

let APIGetBusinessOrderRequests = "\(WEBSERVICE_PATH)GetBusinessOrderRequests"
let APIGetAllBusinessOrders = "\(WEBSERVICE_PATH)GetAllBusinessOrders"

let APIGetBusinessDrivers = "\(WEBSERVICE_PATH)GetBusinessDrivers"
let APIGetAllBusinessDrivers = "\(WEBSERVICE_PATH)GetAllBusinessDrivers"
let APIGetBusyDriverOrderDetails = "\(WEBSERVICE_PATH)GetBusyDriverOrderDetails"


//let APISaveBusinessAccountDetail = "\(WEBSERVICE_PATH)SaveBusinessAccountDetail"

//MARK:- SOKET API

//Socket Path
//let SOCKET_SERVER_PATH = "http://18.223.15.96:3080" //http://192.168.100.174:8055" //"https://apps.narola.online:5002"

let LOCAL_SOCKET_SERVER_URL = "http://192.168.100.174:8055"
let LIVE_SOCKET_SERVER_URL = "http://18.223.15.96:3080"
let SOCKET_SERVER_PATH = isLive ?  LIVE_SOCKET_SERVER_URL : LOCAL_SOCKET_SERVER_URL

let API_SOCKET_JOIN = "join_socket"
let API_SOCKET_DISCONNECT = "disconnect_manually"
let API_SOCKET_JOIN_BUSINESS_ROOM = "JoinBusinessRoom"
let API_SOCKET_LEAVE_BUSINESS_ROOM = "LeaveBusinessRoom"
let API_SHOP_ORDER_REQUEST = "shop_order_request"
let API_SHOP_ORDER_REQUEST_TIMEOUT = "shop_order_request_timeout"
let API_GET_REJECT_REASONS = "getRejectReasons" //getRejectReasons
let API_SHOP_REJECT_ORDER = "shopRejectOrder"
let API_SHOP_ACCEPT_ORDER = "shopAcceptOrder"
let API_SHOP_ORDER_ACCEPTED_BY_OTHER = "shop_order_accepted_by_other"
let API_SHOP_ORDER_REJECTED_BY_OTHER = "shop_order_rejected_by_other"
let API_SOCKET_START_DRIVER_LOCATION_UPDATE = "startDriverLocationUpdate"
let API_SOCKET_STOP_DRIVER_LOCATION_UPDATE = "stopDriverLocationUpdate"
let API_DRIVER_AVAILABILITY_CHANGE_ACK = "driver_availibility_change_ack"
let API_SOCKET_DRIVER_LOCATION_CHANGED = "driver_location_changed_ack"
let API_GET_DRIVER_RUNNNING_ORDER_DETAIL = "getDriverRunningOrderDetail"
let API_CHANGE_TAKEAWAY_ORDER_STATUS = "changeTakeawayOrderStatus"
let API_ORDER_STATUS_CHANGE_ACK = "order_status_change_ack"
let API_GET_SINGLE_ORDER_DETAILS = "getSingleOrderDetails"
let API_SAVE_BUSINESS_ACCOUNT_DETAIL = "\(WEBSERVICE_PATH)SaveBusinessAccountDetail"


//Paths
var PATH_shop : String {
    get{
        getURL(forType: .shop)?.urlFormat ?? ""
    }
}
var PATH_shopGallery : String {
    get{
        getURL(forType: .shopGallery)?.urlFormat ?? ""
    }
}
var PATH_product : String {
    get{
        getURL(forType: .product)?.urlFormat ?? ""
    }
}
var PATH_productGallery : String {
    get{
        getURL(forType: .productGallery)?.urlFormat ?? ""
    }
}
var PATH_users : String {
    get{
        getURL(forType: .users)?.urlFormat ?? ""
    }
}
var PATH_driver : String {
    get{
        getURL(forType: .driver)?.urlFormat ?? ""
    }
}
var PATH_orders : String {
    get{
        getURL(forType: .orders)?.urlFormat ?? ""
    }
}

//Model `
let WSUSER = "User"
