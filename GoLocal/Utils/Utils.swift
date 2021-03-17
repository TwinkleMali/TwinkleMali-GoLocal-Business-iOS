//
//  Utils.swift
//  GoLocal
//
//  Created by C100-104on 16/12/20.
//

import Foundation
import UIKit
import CoreLocation

// MARK: - Common

func makeCircular(view : UIView) {
    view.layer.cornerRadius = view.frame.size.height/2
    view.layer.masksToBounds = true
}

func getAppDelegate() -> Any? {
    return UIApplication.shared.delegate as? AppDelegate
}

func drawBorder(view: UIView?, color borderColor: UIColor?, width: Float, radius: Float) {
    view?.layer.borderColor = borderColor?.cgColor
    view?.layer.borderWidth = CGFloat(width)
    view?.layer.cornerRadius = CGFloat(radius)
    view?.layer.masksToBounds = true
}

func drawBorder1(view: UIView?, color borderColor: UIColor?, width: Float, radius: Float) {
    view?.layer.borderColor = borderColor?.cgColor
    view?.layer.borderWidth = CGFloat(width)
    view?.layer.cornerRadius = CGFloat(radius)
    // view?.layer.masksToBounds = true
}

func drawShadow(view : UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 0)
    view.layer.shadowRadius = 6
    view.layer.shadowOpacity = 0.5
}

func roundingCorners(_ view: UIView?, byRoundingCorners Corners: UIRectCorner, size Points: CGSize) {
    let maskPath = UIBezierPath(roundedRect: view?.bounds ?? CGRect.zero, byRoundingCorners: Corners, cornerRadii: Points)
    
    let maskLayer = CAShapeLayer()
    maskLayer.frame = view?.bounds ?? CGRect.zero
    maskLayer.path = maskPath.cgPath
    view?.layer.mask = maskLayer
    view?.layer.masksToBounds = true
}

func getSecondsBetweenDates(date1 : Date, date2 : Date,orderTimerValue: Double) -> TimeInterval{
    let difference = Calendar.current.dateComponents([.second], from: date2, to: date1)
    let seconds = difference.second ?? 0
    return Double(orderTimerValue) - Double(seconds)
}


func serverToLocal(date:String) -> Date? {
    //   print(date)
    let dateFormatter = DateFormatter()
    //let tempLocale = dateFormatter.locale // save locale temporarily
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var date1 = dateFormatter.date(from: date)!
    date1 = date1.UTCtoLocal().toDate()!
    return date1
}

func socketRejectOrderRequest(dictionary : [String : Any]){
    switch APP_DELEGATE?.socketIOHandler?.socket?.status{
        case .connected?:
            if (APP_DELEGATE!.socketIOHandler!.isJoinSocket){
                APP_DELEGATE!.socketIOHandler?.RejectOrderRequest(dictionary: dictionary)
            }
            break
        default:
            break
    }
}

func socketOrderStatusChanged(dictionary : [String : Any]){
    switch APP_DELEGATE?.socketIOHandler?.socket?.status{
        case .connected?:
            if (APP_DELEGATE!.socketIOHandler!.isJoinSocket){
                APP_DELEGATE!.socketIOHandler?.changeTakeawayOrderStatus(dictionary: dictionary)
            }
            break
        default:
            break
    }
}

func socketGetOrderDetail(strOrder : String){
    switch APP_DELEGATE?.socketIOHandler?.socket?.status{
        case .connected?:
            if (APP_DELEGATE!.socketIOHandler!.isJoinSocket){
                APP_DELEGATE!.socketIOHandler?.getSingleOrderDetails(orderId: strOrder)
            }
            break
        default:
            break
    }
}

func socketAcceptOrderRequest(dictionary : [String : Any]){
    switch APP_DELEGATE?.socketIOHandler?.socket?.status{
        case .connected?:
            if (APP_DELEGATE!.socketIOHandler!.isJoinSocket){
                APP_DELEGATE!.socketIOHandler?.AcceptOrderRequest(dictionary: dictionary)
            }
            break
            
        case .connecting?:
            socketAcceptOrderRequest(dictionary: dictionary)
        break
            
        case .disconnected:
            APP_DELEGATE?.socketIOHandler?.foreground()
            socketAcceptOrderRequest(dictionary: dictionary)
        break
        
        default:
            break
    }
}

//MARK: - CHANGE PLACEHOLDER COLOR
func changePlaceholderColor(_ txtField: UITextField?, placecolor color: UIColor?) {
    let strplaceholderText = txtField?.placeholder
    var str: NSAttributedString? = nil
    if let color = color {
        str = NSAttributedString(string: strplaceholderText ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: color
            ])
    }
    txtField?.attributedPlaceholder = str
}

//MARK: - DESIGNING FUNCTIONS
func calculateFontForWidth(size : CGFloat) -> CGFloat {
    return (SCREEN_WIDTH * size)/SCREEN_WIDTH_FOR_ORIGINAL_FONT
}

func calculateFontForHeight(size : CGFloat) -> CGFloat {
    return (SCREEN_HEIGHT * size)/SCREEN_HEIGHT_FOR_ORIGINAL_FONT
}

func scaleFont(byWidth control: UIView?) {
    if (control is UILabel) {
        (control as? UILabel)?.adjustsFontSizeToFitWidth = true
        (control as? UILabel)?.minimumScaleFactor = 0.5
        (control as? UILabel)?.baselineAdjustment = .alignCenters
        (control as? UILabel)?.lineBreakMode = .byClipping
    } else if (control is UIButton) {
        (control as? UIButton)?.titleLabel?.adjustsFontSizeToFitWidth = true
        (control as? UIButton)?.titleLabel?.minimumScaleFactor = 0.5
        (control as? UIButton)?.titleLabel?.baselineAdjustment = .alignCenters
        (control as? UIButton)?.titleLabel?.lineBreakMode = .byClipping
    } else if (control is UITextField) {
        (control as? UITextField)?.adjustsFontSizeToFitWidth = true
        (control as? UITextField)?.minimumFontSize = 0.5
    }
}

//MARK: - REMOVE WHITE SPACE CHARACTERS FROM STRING
func removeWhiteSpaceCharacter(fromText str : String) -> String {
    var str = str
    str = str.trimmingCharacters(in: CharacterSet.whitespaces)
    str = str.trimmingCharacters(in: CharacterSet.newlines)
    str = str.trimmingCharacters(in: CharacterSet.whitespaces)
    return str
}

//MARK: - ANIMATION
func doScaleAnimation(sender : UIView, scale : CGFloat, duration : CGFloat, completion:@escaping (Bool) -> ()){
    UIView.animate(withDuration: TimeInterval(duration), animations: {
        sender.transform = CGAffineTransform(scaleX: scale, y: scale)
    }, completion: { _ in
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { _ in
             completion(true)
        })
    })
}
//MARK:- ADD DASHED BOARDER
func addDashedBorder(withColor : UIColor, view : UIView) {
//    let frameSize = view.frame.size
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.gray.cgColor
    shapeLayer.lineWidth = 1
    // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
    shapeLayer.lineDashPattern = [7,3]
    let path = CGMutablePath()
    path.addLines(between: [CGPoint(x: view.bounds.minX, y: view.bounds.minY),
                            CGPoint(x: view.bounds.maxX, y: view.bounds.minY)])
    shapeLayer.path = path    
    view.layer.addSublayer(shapeLayer)
}

func addDashedCircle(withColor : UIColor, view : UIView) {
    let circleLayer = CAShapeLayer()
    circleLayer.path = UIBezierPath(ovalIn: view.bounds).cgPath
    circleLayer.lineWidth = 0.5
    circleLayer.strokeColor =  withColor.cgColor//border of circle
    circleLayer.fillColor = UIColor.clear.cgColor//inside the circle
    circleLayer.lineJoin = .round
    circleLayer.lineDashPattern = [2,2]
    view.layer.addSublayer(circleLayer)
}


func getWeekDates(from date : Date) -> [Date]
{
    let day = DateFormatter(format: "EEE").string(from: date)
    print("Day : ",day )
    var newDate = date
    switch day {
    case weekDay.mo.rawValue:
        newDate = Calendar.current.date(byAdding: .day, value: -5, to: date)!
        break
    case weekDay.tu.rawValue:
        newDate = Calendar.current.date(byAdding: .day, value: -6, to: date)!
        break
    case weekDay.we.rawValue:
        newDate = Calendar.current.date(byAdding: .day, value: 0, to: date)!
        break
    case weekDay.th.rawValue:
        newDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        break
    case weekDay.fr.rawValue:
        newDate = Calendar.current.date(byAdding: .day, value: -2, to: date)!
        break
    case weekDay.sa.rawValue:
        newDate = Calendar.current.date(byAdding: .day, value: -3, to: date)!
        break
    case weekDay.su.rawValue:
        newDate = Calendar.current.date(byAdding: .day, value: -4, to: date)!
        break
    default:
        break
    }
    //selectWeek(From: newDate)
    var weekDates : [Date] = []
    for index in 0...6
    {
       weekDates.append(Calendar.current.date(byAdding: .day, value: index, to: newDate)!)
    }
    return weekDates
}

func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}


