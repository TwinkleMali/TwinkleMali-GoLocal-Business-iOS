//
//  LoginViewController.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import UIKit
import NotificationBannerSwift
class LoginViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var LoginLabelTopConstraint: NSLayoutConstraint! {
        didSet{
            LoginLabelTopConstraint.constant =  calculateFontForHeight(size: 60)
        }
    }
    @IBOutlet weak var btnSkip: UIButton!{
        didSet{
            btnSkip.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 17))
        }
    }
    @IBOutlet weak var lblWelcomeText: UILabel!{
        didSet{
            lblWelcomeText.font = UIFont(name: fFONT_BOLD, size: calculateFontForWidth(size: 25))
        }
    }
    @IBOutlet weak var lblWelcomeSubText: UILabel!{
        didSet{
            lblWelcomeSubText.font = UIFont(name: fFONT_MEDIUM, size: 17.0)
        }
    }
    @IBOutlet weak var lblLoginText: UILabel!{
        didSet{
            lblLoginText.font = UIFont(name: fFONT_BOLD, size: calculateFontForWidth(size: 25))
        }
    }
    @IBOutlet weak var lblLoginSubText: UILabel!{
    didSet{
        lblLoginSubText.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 18))
    }
}
    
    
    
    var activityIndicator: UIActivityIndicatorView? {
        get{
            if let cell = tableView.cellForRow(at: IndexPath(row: LoginField.loginButton.rawValue, section: 0)) as? CommonButtonTVCell{
                return cell.activityIndicator
            }
            return nil
        }
    }
    var isRemember =  false
    //MARK:- VARIABLES
    var dataSource: LoginViewDataSource?
    var viewModel = LoginViewModel()
    var isFromLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSkip.isHidden = true
        self.btnBack.isHidden = !isFromLocation
        mainView.layer.cornerRadius = 45
        mainView.clipsToBounds = true
        mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        self.dataSource = LoginViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        if let data = LOGIN_CREDENTIALS {
            viewModel.setEmail(value: data.email)
            viewModel.setPassword(value: data.password)
            self.isRemember = true
        }
        tableView.delegate = self.dataSource
        tableView.dataSource = self.dataSource
       
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .blackOpaque
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSkipLogin(_ sender: Any) {
    }
    @objc func actionForgotPassword(_ sender : UIButton) {
        let vc = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: .main)
        self.navigationController?.pushViewController(vc, animated: true)

    }
   
    @objc func actionRememberMe(_ sender : UIButton) {
        self.isRemember = sender.isSelected
        print("Curr Remember Me :",self.isRemember)

    }
    @objc func actionDoLogin(_ sender : UIButton) {
//        self.navigateToTakeAwayHome()
//        return
        if validate() {
            self.doLogin()
        }
    }
    
    func validate() -> Bool{
        if let emailCell = tableView.cellForRow(at: IndexPath(row: LoginField.email.rawValue, section: 0)) as? CommonTextFieldTVCell {
            emailCell.textField.resignFirstResponder()
        }
        if let passCell = tableView.cellForRow(at: IndexPath(row: LoginField.password.rawValue, section: 0)) as? CommonTextFieldTVCell {
            passCell.textField.resignFirstResponder()
        }
        if viewModel.getEmail() == nil && viewModel.getPassword() == nil {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: validationMethod.getEnterValidDataMessage(.validLoginCredentials), leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }
        guard let email =  viewModel.getEmail() else {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: validationMethod.getEnterMessage(.emailAddress), leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: validationMethod.getEnterValidDataMessage(.emailAddress), leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }
        if !(email.isEmail) {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: validationMethod.getEnterValidDataMessage(.emailAddress), leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }
        guard let password =  viewModel.getPassword() else {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: validationMethod.getEnterMessage(.password), leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }
        if password.count < 6 {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: VALIDATION_MESSAGE.invalidPassword.rawValue, leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }

        return true
    }
    
    func showVerifyAlert(){
        let vc = ModelViewController(nibName: "ModelViewController", bundle: nil)
            vc.setView(){
                (response) in
                if response == .success {
                    self.doLogin()
                }
            }
            self.present(vc, animated: true, completion: nil)
    }
    
    func activityIndicatoris(animate : Bool){
        if let cell = tableView.cellForRow(at: IndexPath(row: LoginField.loginButton.rawValue, section: 0)) as? CommonButtonTVCell{
            if animate {
                cell.activityIndicator.startAnimating()
            } else {
                cell.activityIndicator.stopAnimating()
            }
        }
    }
}
