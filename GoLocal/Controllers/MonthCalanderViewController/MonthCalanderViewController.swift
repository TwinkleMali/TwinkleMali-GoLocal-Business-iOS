//
//  MonthCalanderViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 01/03/21.
//

import UIKit

protocol MonthCalanderDelegate {
    func getSelectedMonth(vc: MonthCalanderViewController,selectedmonth: Int,year: String,yearString: String)
}
class MonthCalanderViewController: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblyearTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var calanderView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var viewBG: UIView!
    
    var arrMonthsTitle = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    //var isButtontag: Int?
    var delegateMonthCalander: MonthCalanderDelegate?
    var arrYears : [Date] = []
    var selectedMonth = -1, selectedYear = ""
    var currentMonth: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register("CalenderMonthCell")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        gesture.numberOfTapsRequired = 1
        viewBG.addGestureRecognizer(gesture)
        //if selectedYear == ""
        //{
            arrYears = getYears(from: Date())
        //}
        let currentmonth = Calendar.current.dateComponents([.month,.year], from: Date())
        currentMonth = selectedMonth < 0 ? currentmonth.month : 0
        selectedYear = selectedYear != "" ? selectedYear : DateFormatter(format: "yyyy").string(from: arrYears.last!)
        print(selectedYear)
        setupYear()
    }
    func getYears(from date : Date) -> [Date]
    {
        
        //selectWeek(From: newDate)
        var years : [Date] = []
        for index in -10...0
        {
           years.append(Calendar.current.date(byAdding: .year, value: index, to: date)!)
        }
        return years
    }
    func setupYear() {
        print("current",DateFormatter(format: "yyyy").string(from: Date()))
        if selectedYear >= DateFormatter(format: "yyyy").string(from: Date())
        {
            btnNext.isHidden = true
        }else{
            btnNext.isHidden = false
        }
        if selectedYear != ""{
            lblyearTitle.text = selectedYear
        }else{
            lblyearTitle.text = "\(DateFormatter(format: "yyyy").string(from: arrYears.last!))"
        }
        collectionView.reloadData()
    }
    @objc func dismissVC() {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func btnNext(_ sender: UIButton) {
        let temp = Calendar.current.date(byAdding: .year, value: 1, to: arrYears.last!)
        arrYears.removeAll()
        arrYears.append(temp!)
        selectedYear = DateFormatter(format: "yyyy").string(from: arrYears.last!)
        lblyearTitle.text = selectedYear
        setupYear()
    }
    @IBAction func btnOk(_ sender: Any) {
        let monthName = arrMonthsTitle[selectedMonth ?? 0]
        delegateMonthCalander?.getSelectedMonth(vc: self,
                                                selectedmonth: selectedMonth + 1,
                                                year: "\(DateFormatter(format: "yyyy").string(from: arrYears.last!))",
                                                yearString: monthName)
        collectionView.reloadData()
        dismiss(animated: false, completion: nil)
    }
    @IBAction func btnPrevious(_ sender: UIButton) {
        let temp = Calendar.current.date(byAdding: .year, value: -1, to: arrYears.last!)
        arrYears.removeAll()
        arrYears.append(temp!)
        lblyearTitle.text = DateFormatter(format: "yyyy").string(from: arrYears.last!)
        selectedYear = DateFormatter(format: "yyyy").string(from: arrYears.last!)
        setupYear()
    }
    @objc func actionMonthClick(_ sender: UIButton){
        selectedMonth = sender.tag
        collectionView.reloadData()
//        let monthName = arrMonthsTitle[selectedMonth ?? 0]
//        delegateMonthCalander?.getSelectedMonth(vc: self, selectedmonth: selectedMonth + 1,year: "\(DateFormatter(format: "yyyy").string(from: arrYears.last!))",yearString: monthName)
        
        
    }
}
extension MonthCalanderViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMonthsTitle.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderMonthCell", for: indexPath) as? CalenderMonthCell{
            cell.lblMonth.text =  arrMonthsTitle[indexPath.row]
            cell.lblMonth.tag = indexPath.row
            
            if selectedMonth == indexPath.row {
                cell.backView.backgroundColor = GreenColor
                cell.lblMonth.textColor = .white
            }else{
                if selectedYear != ""{
                    if selectedMonth < 0 && indexPath.row == currentMonth! - 1{
                        cell.backView.backgroundColor = GreenColor
                        cell.lblMonth.textColor = .white
                    }else{
                        cell.backView.backgroundColor = LightGray
                        cell.lblMonth.textColor = .black
                    }
                }
            }
            let currentmonth1 = Calendar.current.dateComponents([.month,.year], from: Date())
            if selectedYear != ""{
            if selectedYear == String(currentmonth1.year!).description{
                if indexPath.row > currentmonth1.month! - 1{
                    cell.lblMonth.isUserInteractionEnabled = false
                    cell.isUserInteractionEnabled = false
                    cell.lblMonth.alpha = 0.5
                    cell.backView.backgroundColor = LightGray
                    cell.lblMonth.textColor = .black
                }else{
                    cell.lblMonth.isUserInteractionEnabled = true
                    cell.isUserInteractionEnabled = true
                    cell.lblMonth.alpha = 1
                }
            }else{
                cell.lblMonth.isUserInteractionEnabled = true
                cell.isUserInteractionEnabled = true
                cell.lblMonth.alpha = 1
            }
            }else{
                if indexPath.row > currentmonth1.month! - 1{
                    cell.lblMonth.isUserInteractionEnabled = false
                    cell.isUserInteractionEnabled = false
                    cell.lblMonth.alpha = 0.5
                }else{
                    cell.lblMonth.isUserInteractionEnabled = true
                    cell.isUserInteractionEnabled = true
                    cell.lblMonth.alpha = 1
                }
            }
//            if indexPath.row > currentmonth1.month! - 1{
//                cell.btnMonths.isUserInteractionEnabled = false
//                cell.btnMonths.alpha = 0.5
//            }else{
//                cell.btnMonths.isUserInteractionEnabled = true
//                cell.btnMonths.alpha = 1
//            }
            //cell.btnMonths.addTarget(self, action: #selector(actionMonthClick(_:)), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let width = (collectionView.frame.size.width / 3) - 5
        let height = (collectionView.frame.size.height / 4)
        return CGSize(width: width, height: height)
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMonth = indexPath.row
        collectionView.reloadData()
    }
}
