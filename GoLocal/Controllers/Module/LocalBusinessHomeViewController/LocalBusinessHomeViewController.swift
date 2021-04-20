//
//  LocalBusinessHomeViewController.swift
//  GoLocal
//
//  Created by C100-104 on 19/03/21.
//

import UIKit

class LocalBusinessHomeViewController: BaseViewController {

    @IBOutlet weak var btnShowScanner: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func actionShowScanner(_ sender: Any) {
        if !requestCameraPermission() {
            alertPromptToAllowCameraAccessViaSetting()
        } else {
            let vc = ScannerViewController(nibName: "ScannerViewController", bundle: .main)
            vc.modalPresentationStyle = .overFullScreen
            vc.setView { (scannedValue) in
                if scannedValue.count > 0 {
                    let vc1 = PaymentOptionViewController(nibName: "PaymentOptionViewController", bundle: .main)
                    vc1.scannedQRCode = scannedValue
                    self.navigationController?.pushViewController(vc1, animated: true)
                }
            }
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
}
