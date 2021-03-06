//
//  BottomSheetVC.swift
//  GoLocalDriver
//
//  Created by C110 on 29/01/21.
//

import UIKit
import SwiftyJSON

protocol BottomSheetDelegate
{
    func didSelectOption(selValue:String)
}

class BottomSheetVC: UIViewController {
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.layer.cornerRadius = 35
            mainView.clipsToBounds = true
            mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    var delegate : BottomSheetDelegate?
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnClearFilter: UIButton!
    @IBOutlet weak var clearButtonHeight: NSLayoutConstraint! // 0 / 44
    var strTitle : String = ""
    var arrOptions : [String]!
    var arrRejectOptions : [RejectReasons] = []
    var selectedOption : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strTitle
        self.tableView.tableFooterView = UIView()
        self.tableView.register("BottomSheetCell")
        self.tableView.register("CommonButtonTVCell")
        if strTitle == BS_REJECT_REASON{
            clearButtonHeight.constant = 0
            btnClearFilter.isHidden = true
            if USER_DEFAULTS.contains(key: defaultsKey.RejectReasons.rawValue){
                let arrReason = USER_DEFAULTS.array(forKey: defaultsKey.RejectReasons.rawValue)! as NSArray
                for reasonObj in arrReason{
                    arrRejectOptions.append(RejectReasons(object: JSON(reasonObj)))
                }               
                tableView.reloadData()
            }
        } else {
            clearButtonHeight.constant = 44
            self.btnClearFilter.isUserInteractionEnabled = selectedOption > -1
            self.btnClearFilter.alpha = selectedOption > -1 ? 1 : 0.5
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if(touch?.view?.tag == -786) {
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.clear
            } completion: { (_) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func actionSelection(_ sender: UIButton) {
        if selectedOption != nil{
            
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.clear
            } completion: { (_) in
                self.dismiss(animated: true, completion: nil)
                self.delegate?.didSelectOption(selValue: self.arrRejectOptions[self.selectedOption].reason ?? "")
            }
        }
    }
    
    @IBAction func actionClearfilter(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.clear
        } completion: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.didSelectOption(selValue: "Clear")
        }
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.clear
        } completion: { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension BottomSheetVC : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if strTitle == BS_REJECT_REASON{
            return  arrRejectOptions.count + 1
        }else {
            return  arrOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if strTitle == BS_REJECT_REASON{
            if indexPath.row < arrRejectOptions.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetCell", for: indexPath) as! BottomSheetCell
                cell.lblTitle.text = arrRejectOptions[indexPath.row].reason
                if selectedOption != nil && indexPath.row == selectedOption {
                    cell.btnselect.setImage(UIImage(named: "icon_radio_select"), for: .normal)
                }else {
                    cell.btnselect.setImage(UIImage(named: "icon_radio_unselect"), for: .normal)
                }
                cell.selectionStyle = .none
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as! CommonButtonTVCell
                cell.btnSubmit.setTitle("Confirm", for: .normal)
                cell.btnSubmit.addTarget(self, action: #selector(self.actionSelection(_:)),for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        }else {
            let str = arrOptions[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetCell", for: indexPath) as! BottomSheetCell
            cell.lblTitle.text = str
            if selectedOption != nil && indexPath.row == selectedOption {
                cell.btnselect.setImage(UIImage(named: "icon_radio_select"), for: .normal)
            }else {
                cell.btnselect.setImage(UIImage(named: "icon_radio_unselect"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if strTitle == BS_REJECT_REASON{
            selectedOption = indexPath.row
            tableView.reloadData()
        }else {
            let str = arrOptions[indexPath.row]
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.clear
            } completion: { (_) in
                self.dismiss(animated: true, completion: nil)
                self.delegate?.didSelectOption(selValue: str)
            }
        }
    }
}


