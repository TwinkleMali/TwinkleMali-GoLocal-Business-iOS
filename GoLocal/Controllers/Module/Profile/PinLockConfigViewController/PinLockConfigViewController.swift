//
//  PinLockConfigViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 23/06/21.
//

import UIKit

class PinLockConfigViewController: BaseViewController {

    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17))
        }
    }
    @IBOutlet weak var lblSwitchText: UILabel!{
        didSet{
            lblSwitchText.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
        }
    }
    @IBOutlet weak var btnChangePin: UIButton!{
        didSet{
            btnChangePin.titleLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
        }
    }
    @IBOutlet weak var viewChangePin: UIView!
    @IBOutlet weak var lblDescription: UILabel!{
        didSet{
            lblDescription.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 14))
        }
    }
    @IBOutlet weak var switchPinLock: UISwitch!
    
    private var configuration: PasscodeLockConfigurationType? = nil

    init(configuration: PasscodeLockConfigurationType) {
        self.configuration = configuration

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    required init?(coder aDecoder: NSCoder) {
//        let repository = UserDefaultsPasscodeRepository()
//        configuration = PasscodeLockConfiguration(repository: repository)
//
//        super.init(coder: aDecoder)
//    }
    override func viewDidLoad() {
        updatePasscodeView()
    }

    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    @IBAction func switchChange(_ sender: UISwitch) {
        let passcodeVC: PasscodeLockViewController

        if sender.isOn {
            passcodeVC = PasscodeLockViewController(state: .set, configuration: configuration!)

        } else {
            passcodeVC = PasscodeLockViewController(state: .remove, configuration: configuration!)
        }
        passcodeVC.modalPresentationStyle = .overFullScreen
        passcodeVC.setHandler(isforCancel: !sender.isOn) { result in
            self.updatePasscodeView()
        }
        present(passcodeVC, animated: true, completion: nil)
    }
    
    @IBAction func actionChangePin(_ sender: UIButton) {
        let repo = UserDefaultsPasscodeRepository()
        let config = PasscodeLockConfiguration(repository: repo)

        let passcodeLock = PasscodeLockViewController(state: .change, configuration: config)
        passcodeLock.modalPresentationStyle = .overFullScreen
        passcodeLock.setHandler(isforCancel: false) { result in
            self.updatePasscodeView()
        }
        present(passcodeLock, animated: true, completion: nil)
    }
    
    func updatePasscodeView() {
        let hasPasscode = configuration?.repository.hasPasscode
        
        viewChangePin.isHidden = !hasPasscode!
        switchPinLock.isOn = hasPasscode!
    }
}
