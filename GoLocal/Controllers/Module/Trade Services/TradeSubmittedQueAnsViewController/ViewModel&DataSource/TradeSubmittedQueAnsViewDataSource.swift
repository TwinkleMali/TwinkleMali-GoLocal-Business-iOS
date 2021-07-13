//
//  TradeSubmittedQueAnsViewDataSource.swift
//  GoLocal
//
//  Created by C100-104 on 02/06/21.
//

import Foundation
import UIKit
class TradeSubmittedQueAnsViewDataSource : NSObject{
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: TradeSubmittedQueAnsViewModel
    private let viewController: UIViewController
    private var tradeSubmittedQueAnsViewController : TradeSubmittedQueAnsViewController? {
        get{
            viewController as? TradeSubmittedQueAnsViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: TradeSubmittedQueAnsViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("SingleAddonsItemTVCell")
        tableView.register("CollectionViewTVCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
extension TradeSubmittedQueAnsViewDataSource : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getSectionCount()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getRowCount(for: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 && viewModel.getImagesCount() > 0 {
            let imgeCount = viewModel.getImagesCount()
            let cnt = Float(imgeCount / 3).rounded(.up)
            let height = (SCREEN_WIDTH/3)
            return CGFloat(cnt > 0 ? height*CGFloat(cnt) : height)
        } else {
            return UITableView.automaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.001
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        0.001
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        0.001
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 && viewModel.getImagesCount() > 0 {
//            return "Attachments"
//        }
//        return "Question Answers"
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && viewModel.getImagesCount() > 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTVCell", for: indexPath ) as? CollectionViewTVCell {
                cell.selectionStyle = .none
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                return cell
            }
        } else {
            let index = viewModel.getImagesCount() > 0 ? section - 1 : section
            if row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "QuestionsTVCell")
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                let QA = self.viewModel.getQueAns(atPos: index)
                cell.textLabel?.attributedText = getAttributedText(value1: QA.question ?? "", value2: "")
                cell.textLabel?.text = QA.question ?? ""
//                cell.textLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 16))
                cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "QuestionsTVCell")
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                let QA = self.viewModel.getQueAns(atPos: index)
                cell.textLabel?.attributedText = getAttributedText(value1: "", value2: QA.optionValue ?? "")
                //cell.textLabel?.text = QA.optionValue ?? ""
                cell.textLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    func getAttributedText(value1:String,value2:String) -> NSMutableAttributedString{
        
            let size = calculateFontForWidth(size: 16)
            let size2 = calculateFontForWidth(size: 15)
        
        let headerAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_SEMIBOLD, size: size)!, NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_SEMIBOLD, size: size)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray]
            
            let firstString = NSMutableAttributedString(string: value1, attributes: headerAttributes)
            let secondString = NSMutableAttributedString(string: value2, attributes: textAttributes)
            //let thirdString = NSMutableAttributedString(string: value3, attributes: textAttributes)
            
            //secondString.append(thirdString)
            firstString.append(secondString)
            
            let paragraphStyle2 = NSMutableParagraphStyle()
            paragraphStyle2.lineSpacing =  10
            paragraphStyle2.alignment = .left
            firstString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle2, range:NSMakeRange(0, firstString.length))
            
            return firstString
            
    }
}
extension TradeSubmittedQueAnsViewDataSource : UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleImageCVCell", for: indexPath) as? SingleImageCVCell {
            let attachment = viewModel.getAttachement(atPos: indexPath.item)
            if let imgName = attachment.fileName{
                cell.imageView.startShimmering()
                let finalPath = PATH_TradeAttachments.replacingOccurrences(of: "{ImageName}", with: imgName) // + "/" + imgName
                let imgUrl = URL(string: finalPath)
                cell.imageView.sd_setImage(with: imgUrl, placeholderImage: STORE_LIST_IMAGES_PLACEHOLDER){ (_, _, _) in
                    
                } completed: { (_, _, _, _) in
                    cell.imageView.stopShimmering()
                }
            }
            //cell.imageView.image =
            cell.imgCancel.isHidden = true
            return cell
        }
        let cell = UICollectionViewCell()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath ) as? SingleImageCVCell else {
            return
        }
        let newImageView = UIImageView(image: cell.imageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
        self.viewController.view.addSubview(newImageView)
        newImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.2) {
            newImageView.transform = .identity
        }
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            sender.view?.transform = CGAffineTransform(scaleX: 0, y: 0)
        } completion: { (_) in
            sender.view?.removeFromSuperview()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width / 3) - 3, height: (collectionView.bounds.width / 3) - 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top, left, bottom, right
        return UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    }
}
