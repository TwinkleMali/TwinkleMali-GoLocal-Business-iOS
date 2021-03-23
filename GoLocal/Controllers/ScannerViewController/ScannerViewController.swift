//
//  ScannerViewController.swift
//  GoLocal
//
//  Created by C100-104 on 18/03/21.
//

import AVFoundation
import UIKit
import SDWebImage

class ScannerViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var viewScanner: QRScannerView! {
        didSet {
            viewScanner.delegate = self
        }
    }
    @IBOutlet weak var imgGIF: SDAnimatedImageView!{
        didSet{
            let anim = SDAnimatedImage(named: "scan.gif")
            imgGIF.image = anim //animatedImage
            
        }
    }
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                print("@ Scanned Text : ",qrData?.codeString ?? "")
                completionHandler(qrData?.codeString ?? "")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    fileprivate var completionHandler: (String) -> () = {scannedValue  in }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !viewScanner.isRunning {
            viewScanner.startScanning()
        }
        //viewScanner.isRunning ? viewScanner.stopScanning() : viewScanner.startScanning()
        dismiss(animated: true, completion: nil)
        completionHandler("4J548_697d60I1069")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !viewScanner.isRunning {
            viewScanner.stopScanning()
        }
    }
  
    @IBAction func actionClose(_ sender: Any) {
        completionHandler("")
        self.dismiss(animated: true, completion: nil)
        
    }
    //MARK:- Functions
    func setView( completion: @escaping (String) -> ()){
        completionHandler = completion
    }
}
extension ScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
//        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
//        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
       // presentAlert(withTitle: "Error", message: )
        print("Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
}




