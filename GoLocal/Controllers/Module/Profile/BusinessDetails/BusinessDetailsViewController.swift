//
//  BusinessDetailsViewController.swift
//  GoLocal
//
//  Created by C110 on 1/2/21.
//

import UIKit
import Photos
import AVFoundation
import SDWebImage

class BusinessDetailsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    var dataSource: BusinessDetailsDataSource?
    var viewModel = BusinessDetailsViewModel()
    var isEditEnable : Bool = false
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let imagePicker = UIImagePickerController()
    var optionView: OptionViewController?
    var arrayImage : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = BusinessDetailsDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.imagePicker.delegate = self
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        getCountryList { (completed) in
            if completed{
                self.getBusinessDetails()
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionEdit(_ sender: UIButton){
        if isEditEnable{
            if validate() {
                editBusinessDetails()
            }
        }else {
            isEditEnable = true
            btnEdit.setTitle("Save", for: .normal)
            tableView.reloadData()
        }
    }
    
    @IBAction func actionShowCodePicker(_ sender: UIButton){
        let vc = CountryCodePickerViewController(nibName: "CountryCodePickerViewController", bundle: .main)
        vc.setUpView(selectedCountry: self.viewModel.getSelectedCountry()) { (selectedCountry) in
            print("\(selectedCountry.name ?? "") - \(selectedCountry.sortname ?? "")")
            self.viewModel.setSelectedCountry(country: selectedCountry)
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: BusinessDetailField.ContactNumber.rawValue)) as? MobileNumberTVCell {
                cell.lblCountryPhoneCode.text = "+\(selectedCountry.phonecode ?? 0)"
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: -   DatePicker Methods
    func showDatePicker(textfield : UITextField){
            //Formate Date
        datePicker.datePickerMode = .time
        datePicker.accessibilityLabel = textfield.accessibilityLabel        
        datePicker.tag = Int(textfield.accessibilityValue ?? "0") ?? 0
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
//            datePicker.minimumDate = Date()
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDatePicker));
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textfield.inputAccessoryView = toolbar
            textfield.inputView = datePicker
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func handleDatePicker() {
        var arrSchedule : [Schedule] = viewModel.getShopSchedule()
        var objTime : Schedule = arrSchedule[datePicker.tag]

        if datePicker.accessibilityLabel == "OpenTime"{
            objTime.openingTime = datePicker.date.toString().toDateString(outputFormat: TIME_FORMATE)
            
        }else if datePicker.accessibilityLabel == "CloseTime"{
            objTime.closingTime = datePicker.date.toString().toDateString(outputFormat: TIME_FORMATE)
        }
        arrSchedule.remove(at: datePicker.tag)
        arrSchedule.insert(objTime, at: datePicker.tag)
        viewModel.removeShopSchedule()
        viewModel.setShopSchedule(shopSchedule: arrSchedule)
        tableView.reloadSections([BusinessDetailField.OpenCloseTime.rawValue], with: .none)
//        tableView.reloadRows(at: [IndexPath(row: datePicker.tag, section: BusinessDetailField.OpenCloseTime.rawValue)], with: .none)
        self.view.endEditing(true)
    }
    
    @objc func btnRadioClick(_ sender: UIButton) {
        if sender.tag == 1{
            viewModel.setDeliveryType(deliveryType: DeliveryType.delivery.rawValue)
        }else  if sender.tag == 2{
            viewModel.setDeliveryType(deliveryType: DeliveryType.collection.rawValue)
        }else if sender.tag == 3{
            viewModel.setDeliveryType(deliveryType: DeliveryType.both.rawValue)
        }
        tableView.reloadRows(at: [IndexPath(row: 0, section: BusinessDetailField.DeliveryType.rawValue)], with: .none)
    }
    
    @objc func btnTimeSwitchClick(_ sender: UIButton) {
        var arrSchedule : [Schedule] = viewModel.getShopSchedule()
        var objTime : Schedule = arrSchedule[sender.tag]
        if objTime.isClosed == 1{
            objTime.isClosed = 0
        }else {
            objTime.isClosed = 1
        }
        arrSchedule.remove(at: sender.tag)
        arrSchedule.insert(objTime, at: sender.tag)
        viewModel.removeShopSchedule()
        viewModel.setShopSchedule(shopSchedule: arrSchedule)
        tableView.reloadSections([BusinessDetailField.OpenCloseTime.rawValue], with: .none)
    }
    
    @objc func btnRemoveImage(_ sender: UIButton) {
        if sender.accessibilityLabel == "OldImage"{
            let objImage : SliderImages = viewModel.getSliderImages()[sender.tag]
            viewModel.setDeletedImage(strValue: objImage.id!)
            viewModel.removeSliderImage(at: sender.tag)
        }else if sender.accessibilityLabel == "NewImage"{
            viewModel.removeImages(at: sender.tag)
        }
        tableView.reloadSections([BusinessDetailField.Images.rawValue], with: .none)
    }
    
    @objc func btnAddImage(_ sender: UIButton) {
        optionView = OptionViewController(nibName: "OptionViewController", bundle: nil)
        optionView?.delegateOptionViewController = self
        optionView?.showScanView(viewDisplay: self.view)
    }
    
    func validate() -> Bool{
        if let storeNameCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.StoreName.rawValue, section: 0)) as? CommonTextFieldTVCell {
            storeNameCell.textField.resignFirstResponder()
        }

        if let storeLocationCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.StoreLocation.rawValue, section: 0)) as? CommonTextFieldTVCell {
            storeLocationCell.textField.resignFirstResponder()
        }
        
        if let emailCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.Email.rawValue, section: 0)) as? CommonTextFieldTVCell {
            emailCell.textField.resignFirstResponder()
        }
        
        if let contactNumCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.ContactNumber.rawValue, section: 0)) as? CommonTextFieldTVCell {
            contactNumCell.textField.resignFirstResponder()
        }
        
        if let websiteCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.Website.rawValue, section: 0)) as? CommonTextFieldTVCell {
            websiteCell.textField.resignFirstResponder()
        }
        
        if let licenseNumCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.LicenseNumber.rawValue, section: 0)) as? CommonTextFieldTVCell {
            licenseNumCell.textField.resignFirstResponder()
        }

//        var strMessage : String = ""
//        if viewModel.getStoreName()?.count == 0 || viewModel.getStoreLocation()?.count == 0 || viewModel.getLatitude()?.count == 0 || viewModel.getCountryId()?.count == 0 || viewModel.getLongitude()?.count == 0 || viewModel.getEmail()?.count == 0 || viewModel.getContactNum()?.count == 0 || viewModel.getWebsite()?.count == 0 || viewModel.getDeliveryType()?.count == 0 ||  viewModel.getLicenseNum()?.count == 0 {
//            strMessage = "Please fill all details"
//        }else {
//            return true
//        }
//        self.showBanner(bannerTitle: .none, message: strMessage, type: .danger)
        return true
    }
    
}

extension BusinessDetailsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            viewModel.setImage(image: image)
            
            tableView.reloadSections([BusinessDetailField.Images.rawValue], with: .none)
        }else{
            print("error")
        }
        dismiss(animated: true, completion: nil)
    }
}


extension BusinessDetailsViewController: OptionViewControllerDelegate{
    func openCamera(vc: OptionViewController) {
       // print("open camera")
        vc.hidescanView()
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                self.allowOpenCamera()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        self.allowOpenCamera()
                    } else {
                        //access denied
                        DispatchQueue.main.async {
                            self.openSettingApp(title: APP_NAME, message: "\(APP_NAME) requires to access your camera to upload receipt image.")
                        }
                    }
                })
            }
    }
    func allowOpenCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: kCHECK_CAMERA, message: kCHECK_CAMERA_MSG, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: kTITLE_OK, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallary(vc: OptionViewController) {
        //print("open photo")
        vc.hidescanView()
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.modalPresentationStyle = .fullScreen
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
        //handle authorized status
            DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .denied, .restricted :
        //handle denied status
            self.openSettingApp(title: APP_NAME, message: "\(APP_NAME) requires to access your photo library to upload receipt  image.")
        break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                DispatchQueue.main.async {
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }else{
                        print("User denied")
                    }
                }})
            break
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    
}
