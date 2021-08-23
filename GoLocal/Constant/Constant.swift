//
//  Constant.swift
//  GoLocal
//
//  Created by C100-104on 16/12/20.
//

import Foundation
import UIKit

//MARK: - CHECK FOR DEVICE
let IS_IPAD = UI_USER_INTERFACE_IDIOM() != .phone

//MARK: - SCREEN BOUNDS
let SCREEN_WIDTH = UIScreen.main.bounds.size.width as CGFloat
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height as CGFloat
let SCREEN_SIZE = UIScreen.main.bounds.size
var HAS_TOP_NOTCH: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

//MARK: - SCREEN WIDTH FOR ORIGINAL FONTS
let SCREEN_WIDTH_FOR_ORIGINAL_FONT = IS_IPAD ? 768 : 414 as CGFloat
let SCREEN_HEIGHT_FOR_ORIGINAL_FONT = IS_IPAD ? 1024 : 896 as CGFloat

//MARK: - GET APPDELEGATE
let APP_DELEGATE = UIApplication.shared.delegate as? AppDelegate

//MARK: - SOME COMMON THINGS
let kCHECK_INTERNET_CONNECTION   =  "Check your internet connection"
let kPROBLEM_FROM_SERVER         =  "Problem Receiving Data From Server"
let kSOMETHING_WENT_WRONG         =  "Something Went Wrong"
let kSERVER_NOT_RESPONDING     = "Server is not responding. Please try again later."
let kCHECK_CAMERA = "Warning"
let kCHECK_CAMERA_MSG = "You don't have camera"
let MESSAGE = "Please try again later."
let kTITLE_OK = "OK"
let kDRIVER_REQUEST_TIME = 60.0
var validationMethod = VALIDATION_METHODS()
var LoginCredentials = LoginDetials()


func saveLoginCredentials(user: LoginDetials) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(user) {
        USER_DEFAULTS.set(encoded, forKey: defaultsKey.loginCredentials.rawValue)
    }
}
var LOGIN_CREDENTIALS: LoginDetials? {
    get {
        if let savedPerson = USER_DEFAULTS.object(forKey: defaultsKey.loginCredentials.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginDetials.self, from: savedPerson) {
            
                return loadedPerson
            }
        } else {
            return nil
        }
        return nil
    }
}

//MARK:- CountryList
var COUNTRY_LIST : [Country] = []

//MARK:- get / set User Data
var USER_ROLE = 3
var TEMP_SHOP_ID = 2
var IsPhoneVerified : Int {
    get {
        USER_DETAILS?.isPhoneVerified ?? 0
    }
}

var DEVICE_UDID : String {
    get{
        UIDevice.current.identifierForVendor?.uuidString ?? "JLTEST-1A2B-3C4D-5E6F-SIMULATOR"
    }
}

var GOOGLE_KEY = "AIzaSyBusjBEjxzIkmDySEwGOHVx_SoD6PQagNo" 
var GOOGLE_ID = "1049357683894-0nfb17pkv6lsdj8gt28pgd3qeibcvahm.apps.googleusercontent.com"
//MARK:- PlaceHolders

let STORE_IMAGES_PLACEHOLDER = #imageLiteral(resourceName: "product_details_placeholder")
let STORE_LIST_IMAGES_PLACEHOLDER = #imageLiteral(resourceName: "product_placeholder")
let STORE_LOGO_PLACEHOLDER = #imageLiteral(resourceName: "store_list_placeholder")

func saveUserInUserDefaults(user: User) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(user) {
        USER_DEFAULTS.set(encoded, forKey: defaultsKey.userDetails.rawValue)
        //USER_DEFAULTS.setValue(user.globalCharacter, forKey: defaultsKey.globalCaracters.rawValue)
    }
}

var USER_DETAILS: User? {
    get {
        if let savedPerson = USER_DEFAULTS.object(forKey: defaultsKey.userDetails.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                print("____USER LOGGED IN AS : ",loadedPerson.username ?? "UnKNown Person")
                return loadedPerson
            }
        } else {
            return nil
        }
        return nil
    }
}
//MARK:- UserDefault Key ENUM
enum defaultsKey : String{
    case userDetails = "userDetails"
    case searchHistory = "searchHistory"
    case loginCredentials = "loginCredentials"
    case firstLaunch = "firstLaunch"
    case rateApp = "rateApp"
    case currentVersion = "currentVersion"
    case lastVersion = "lastVersion"
    case showInitialAd = "showInitialAd"
    case isATTrackingAllows = "isATTrackingAllows"
    case RejectReasons = "RejectReasons"
    case password = "password"
}

//MARK:- VARIABLES
var isNetworkConnected = true
var clickDetact : String = ""
var ACCESS_KEY = "nousername"
var SECRET_KEY = "FEinhS54sNUNNll0tjqNdzLskf3SPgUISZzp1vIZXzE="
var DEVICE_TOKEN = "123456"
var FCM_TOKEN = ""
var TIME_ZONE = TimeZone.current.identifier
let DEVICE_TYPE = 2
let IS_TEST_DATA = "1"
var IS_GPS_ON   = false
var isGuest : Bool = false
var IS_UPDATE_POPUP_SEEN = false
var CURRENT_VERSION = ""
let APP_NAME = "Go Local First Business"
let USER_DEFAULTS = UserDefaults.standard

//MARK:- VARIABLES FOR NOTIFICATION CLICK NAVIGATION
var IS_FROM_PUSH_NOTIFICATION : Bool = false
var PUSH_USER_INFO = [String : Any]()
var IS_APP_OPEN_FROM_NOTIFICATION_LAUNCH : Bool = true
var IS_FROM_LOCAL_NOTIFICATION : Bool = false


//MARK:- Bottomsheet Title
let BS_FILTER = "Filter"
let BS_REJECT_REASON = "Reject Request Option"

//MARK:- UTC Time
let CURRENT_UTC_Date = Date().toString(format: "yyyy-MM-dd")// localToUTC(format: "yyyy-MM-dd")
let CURRENT_UTC_Date_Time = Date().localToUTC(format: "yyyy-MM-dd hh:mm")
var CURRENT_WEEK_DAY : String? {
    get {
        Date().toString(format: "EEEE")
    }
}
//MARK:- Country & Currnecy
var COUNTRY_CODE = NSLocale.current.regionCode ?? ""
var CURRENCY_SYMBOL = "£" //NSLocale.current.currencyCode ?? ""

//MARK:- CONSTANTS
var LOGIN_AS = "Driver"

//MARK:- KEYS
let GoogleSignInKey = ""

//MARK: -  LOCATION
var CURRENT_LATITUDE = 21.195416
var CURRENT_LONGITUDE = 72.792767

//MARK: - FONT NAMES
let fFONT_REGULAR   =   "Montserrat-Regular"
let fFONT_BOLD      =   "Montserrat-Bold"
let fFONT_SEMIBOLD  =   "Montserrat-SemiBold"
let fFONT_BLACK     =   "Montserrat-Black"
let fFONT_LIGHT     =   "Montserrat-Light"
let fFONT_EXTRABOLD =   "Montserrat-ExtraBold"
let fFONT_MEDIUM    =   "Montserrat-Medium"

//MARK: - COLORS
let GreenColor = UIColor(red: 0/255, green: 112/255, blue: 50/255, alpha: 1.0)
let LightGreenColor = UIColor(red: 0/255, green: 112/255, blue: 50/255, alpha: 0.5)
let LightGray = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
let GreenCGColor = UIColor(red: 6/255, green: 77/255, blue: 89/255, alpha: 1.0).cgColor
let strokeColor = UIColor(red: 35/255, green: 138/255, blue: 254/255, alpha: 1.0)
let THEME_COLOR = UIColor(red: 6/255, green: 77/255, blue: 89/255, alpha: 1.0)
let LINK_COLOR = UIColor(red: 47/255, green: 184/255, blue: 235/255, alpha: 1.0)
let VIEW_BACKGROUND_COLOR = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
let SKYBLUE_COLOR = UIColor(red: 0/255, green: 155/255, blue: 243/255, alpha: 1.0)
let GREEN_COLOR = UIColor(red: 0/255, green: 214/255, blue: 103/255, alpha: 1.0)
let RED_COLOR = UIColor(red: 255/255, green: 30/255, blue: 47/255, alpha: 1.0)
let LIGHT_THEME = UIColor(red: 205/255, green: 221/255, blue: 224/255, alpha: 0.9)
let ORANGE_COLOR = UIColor(red: 255/255, green: 161/255, blue: 89/255, alpha: 1.0)

//MARK:- STORYBOARD
let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let LoginStoryboard = UIStoryboard(name: "Login", bundle: nil)
let HomeStoryboard = UIStoryboard(name: "Home", bundle: nil)

//MARK:- SET PATHS IN DEFAULTS
func savePathInUserDefaults(mediaUrl: MediaUrl) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(mediaUrl) {
        USER_DEFAULTS.set(encoded, forKey: "\(URLTypes(rawValue: mediaUrl.type ?? "")?.rawValue ?? "")_url_key")
        //USER_DEFAULTS.setValue(user.globalCharacter, forKey: defaultsKey.globalCaracters.rawValue)
    }
}

func getURL(forType:URLTypes) -> MediaUrl?{
    if let savedURL = USER_DEFAULTS.object(forKey: "\(forType.rawValue)_url_key") as? Data {
        let decoder = JSONDecoder()
        if let loadedUrl = try? decoder.decode(MediaUrl.self, from: savedURL) {
            print("____USER LOGGED IN AS : ",loadedUrl.type ?? "UnKNown URL")
            return loadedUrl
        }
        return nil
    }
    return nil
}
