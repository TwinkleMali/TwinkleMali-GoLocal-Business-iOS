//
//  Enum.swift
//  GoLocal
//
//  Created by C100-104on 16/12/20.
//

import Foundation

//MARK:- Currency

enum Currency_Type : String
{
    case Rupees = "₹"
    case Doller = "$"
    case Euro = "€"
}

//MARK:- WEEKDAY
enum weekDay : String{
   case mo = "Mon"
   case tu = "Tue"
   case we = "Wed"
   case th = "Thu"
   case fr = "Fri"
   case sa = "Sat"
   case su = "Sun"
}
   
//MARK:- LOGIN SCREEN TABLE ROW
enum RegisterationField : Int {
    case username = 0
    case email
    case homePostCode
    case password
    case ConfirmPassword
    case termAndCondition
    case nextButton
}
enum LoginField : Int {
    case email = 0
    case password
    case loginButton
//    case otherLoginType
}

enum ForgotPasswordField : Int {
    case email = 0
    case submitButton
}

enum TAKEAWAY_ORDER_STATUS : Int {
    case ORDER_LEFT = 1
    case DELIVERED
    case CANCELLED
}
enum ORDER_TYPE :String {
    case SCHEDULED = "Scheduled"
    case NORMAL = "Normal"
}

enum EditProfileField : Int {
    case firstname = 0
    case lastname
    case email
    case phoneNumber
    case total = 4
}

enum ChangePasswordField : Int {
    case currentPassword = 0
    case newPassword
    case confirmPassword
    case total = 3
}

enum AddAccountField : Int {
    case bankName = 0
    case accountType
    case accountNumber
    case ifscCode
    case otherDetails
    case submitButton
}

enum OrderDetailsField : Int {
    case requestDetail = 0
    case orderAmount
    case deliveryType
    case note
    case billDetails
    case deliveryPerson
    case total 
}
//Notification types 
enum NOTIFICATION_TYPE : Int
    {
        case NOTIFICATION_DRIVER_VERIFICATION = 1
        case NOTIFICATION_SHOP_ORDER_REQUEST = 2
        case NOTIFICATION_DRIVER_ORDER_REQUEST = 3
        case NOTIFICATION_RATING = 4
        case NOTIFICATION_ORDER_STATUS_CHANGE = 5
        case NOTIFICATION_ORDER_RECEIPT_UPLOADED = 6
        case NOTIFICATION_ORDER_CHAT = 7
        case NOTIFICATION_EARN_POINT = 8
        case NOTIFICATION_PAYMENT_REQUEST = 9
        case NOTIFICATION_PAYMENT_REQUEST_STATUS = 10
        case NOTIFICATION_TRADE_REQUEST = 11
        case NOTIFICATION_TRADE_REQUEST_CANCELLED = 12
        case NOTIFICATION_TRADE_CONFIRM_QUOTATION = 13
        case NOTIFICATION_TRADE_QUOTE_STATUS_CHANGE = 14
        case NOTIFICATION_TRADE_REQUEST_COMPLETED = 15
        case NOTIFICATION_SHOP_BROADCAST_MESSAGE = 16
        case NOTIFICATION_TRADE_SERVICE_EXTRA_CHARGES  = 17
        case NOTIFICATION_EXTRA_CHARGE_STATUS_UPDATE  = 18
        case NOTIFICATION_TRADE_PAYMENT_RECEIVED = 19
        case NOTIFICATION_TRADE_PAYMENT_REQUEST = 20
        case NOTIFICATION_TRADE_SERVICE_PAYMENT_STATUS_CHANGE = 21
        case NOTIFICATION_WEEKLY_PAYMENT = 22
        case NOTIFICATION_CONFIRM_CASH_PAYMENT = 23
        case NOTIFICATION_CASH_PAYMENT_CONFIRMED = 24
    }
//MARK:- Business Home Table Fields
enum PROFILE : Int{
    case PersonalInfo = 0
    case BussinessDetails
    case Notifications
    case ChangePassword
    case ManageBankAccount
    case RatingandReview
    case LocKPin
    case Logout
}

enum PaymentOption : Int{
    case OwnTerminal = 0
    case GoLocalFirst
    case Total = 2
}

enum BusinessDetailField : Int{
    case Images = 0
    case StoreName
    case StoreLocation
    case Email
    case ContactNumber
    case Website
    case DeliveryType
    case LicenseNumber
    case OpenCloseTime
    case Total = 9
}

enum OrderType : Int {
    case CurrentOrder = 1
    case PastOrder
}

enum OrderDetailTab : Int {
    case FirstOrder = 1
    case SecondOrder
}

enum DeliveryType : String{
    case delivery = "Delivery"
    case collection = "Collection"  
    case both = "Both"
}

enum DriverType : Int{
    case GoLocalFirstDrivers = 0
    case OwnDrivers
    case BusyDrivers
    case OfflineDrivers
    case Total = 4
}

enum DriverDetailsField : Int{
    case Map = 0
    case Details
    case EstimatedReturnTime
    case PostalCode
    case Total = 4
}

enum DriverStatus : Int{
    case Offline = 0
    case Available
    case Busy
}

enum URLTypes : String {
    case shop = "Shop"
    case shopGallery = "ShopGallery"
    case product = "Product"
    case productGallery = "ProductGallery"
    case users = "Users"
    case driver = "Driver"
    case orders = "Orders"
    case TradeAttachments = "TrdadeAttachments"
}


enum UserRole : Int{
    case Owner = 3
    case Employee = 1
    case LocalBusiness = 7
    case Trade = 4
}

//MARK:- Custom Alert
enum AlertResult {
    case success
    case failure
}


//MARK:- Banner Type
enum BannerTitle : String {
    case validation = "Validation"
    case invalidCredentials = "Invalid Credentials"
    case underDevelopment = "Under Development"
    case registered = "Registered successfully."
    case none = ""
    case alert = "Alert"
    case success = "Success"
    case failed = "Failed"
    case transection = "Transection"
}

enum OrderStatus : String {
    case Pending = "Pending"
    case AcceptedByShop = "AcceptedByShop"
    case AcceptedByDriver = "AcceptedByDriver"
    case Confirmed = "Confirmed"
    case OrderLeft = "OrderLeft"
    case Delivered = "Delivered"
    case RejectedByShop = "RejectedByShop"
    case Rejected = "Rejected"
    case Cancelled = "Cancelled"
}


//MARK:- VALIDATION
enum VALIDATION_MESSAGE : String {
    case validInformation = "valid informations."
    case validLoginCredentials = "Login Credentials."
    case validCarDetails = "Car Details"
    case photo = "Photo"
    case Code = "Code"
    case phoneNumber = "Phone Number"
    case userName = "Username"
    case postCode = "Postcode"
    case emailAddress = "Email Address"
    case password = "Password"
    case verificationCode = "verification code"
    case invalidPassword = "The password must be have at least 6 characters long."
    case confirmYourPassword = "Please confirm your password."
    case misMatchPassword = "Please make sure your password match."
    case vehicleId = "Vehicle Id"
    case registrationDate = "Registartion date"
    case registrationTime = "Registartion time"
    case vehicleCountry = "Vehicle Country"
    case vehicleCountryCode = "Vehicle country code"
    case vehicleState = "Vehicle state"
    case vehicleType = "Vehicle type"
    case vehicleColorHax = "Vehicle color Hax"
    case vehicleColorName = "Vehicle color name"
    case vehiclePlate = "Vehicle plate"
    case vehicleMake = "Vehicle make"
    case vehicleModel = "Vehicle model"
    case termNotAccepted = "Please accept our terms and privacy"
}


//MARK:- PAYMENT REQUEST STATUS
enum PAYMENT_REQUEST_STATUS : String{
    case ACCEPT = "Accept"
    case CANCELLED = "Cancelled"
    case PAID = "Paid"
}


//Cell Usage
enum CommonTradeCellUsedFor {
    case QuoteationRequest
    case ActiveOrder
    case PastOrder
    case RequestDetails
    case OrderDetails
}


enum QuoteDetailsSection : Int {
    case CustomerAndServiceDetails = 0
    case DepositOptions
    case PaymentOptions
    case BusinessOptionsAndAmount
    case ArrivalTime
    case Quote
    case XtraButtons
}

enum TradePaymentOptions : String {
    case CARD = "Card" // 1
    case CASH = "Cash" // 3
    case BACS = "BACS" // 2
    case APP = "App" // 4
}

enum TradeBusinessOption : String {
    case BUSINESS_A = "Business A"
    case BUSINESS_B = "Business B"
}
enum BusinessB_Option_Types : String {
    case NONE = "None"
    case PER_HOUR = "PerHour"
    case PER_VISIT = "PerVisit"
    case PER_5_VISITS = "Per5Visit"
}
enum depositType : String {
    case NONE = "none"
    case PAY_IN_ADVANCED = "PayInAdvance"
    case PAY_DEPOSIT = "PayDeposit"
}
enum filterOptions : Int{
    case none = 0
    case date
    case month
}

enum TRADE_SERVICE_STATUS : String {
    case REQUESTED = "Requested"
    case ACCEPTED = "Accepted"
    case REJECTED = "Rejected"
    case COMPLETED = "Completed"
    case CANCELLED = "Cancelled"
}

enum TradeOrderDetailScreenField : Int {
    case CustomerAndServiceDetails = 0
    case PaymentDetails
    case note
    case billDetails
    case separator
    case buttons
}
enum ChatMessageType : String {
    case ORDER = "Order"
    case TRADE = "Trade"
}
