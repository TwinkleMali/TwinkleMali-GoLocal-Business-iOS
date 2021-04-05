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

//MARK:- Business Home Table Fields
enum PROFILE : Int{
    case PersonalInfo = 0
    case BussinessDetails
    case Notifications
    case ChangePassword
    case ManageBankAccount
    case RatingandReview
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
}


enum UserRole : Int{
    case Owner = 3
    case Employee = 1
    case LocalBusiness = 7
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
