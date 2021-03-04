//
//  CategoryListViewDataSource.swift
//  GoLocal
//
//  //  Created by C110 on 20/01/21.
//

import Foundation
import UIKit
class CategoryListViewDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
//    private let collectionView : UICollectionView
    private let viewModel: CategoryListViewModel
    private let viewController: UIViewController
    private var productListViewController : ProductListViewController? {
        get{
            viewController as? ProductListViewController
        }
    }
    private var selectedRow : Int = 0
    private var previousSelectedRow : Int = 0
    private var isFirstLaunch = true
    init(tableView: UITableView, viewModel: CategoryListViewModel, viewController: UIViewController) {
//        self.selectedRow = selectedIndex
//        self.previousSelectedRow = selectedIndex
        self.tableView = tableView
//        self.collectionView = collectionView
        self.viewModel = viewModel
        self.viewController = viewController
        self.tableView.register("SingleCategoryTVCell")
//        self.tableView.register("SelectedProductDetailsTVCell")
        
//        self.collectionView.register(UINib(nibName: "SingleCategoryNameCVCell", bundle: nil), forCellWithReuseIdentifier: "SingleCategoryNameCVCell")
    }
}
extension CategoryListViewDataSource : UITableViewDataSource,UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if viewModel.getCategoriesRowCount() > 0,let products = viewModel.getCategory(atPos: selectedRow).products{
//            return products.count
//        }
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if viewModel.getCategoriesRowCount() > 0{
//            let row = viewModel.getRowCountOfSelectedProductcat(categoryIndex: selectedRow, productIndex: section)
//            return row
//        }
        return 2
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCategoryTVCell") as? SingleCategoryTVCell{
//            cell.selectionStyle = .none
//            // assign - (indexPath.section*100)+indexPath.row
//            cell.tag = section
//            cell.btnMore.tag = section
//            cell.lblCategoryName.text = "Italian Food"
//            cell.btnInfo.tag = section
//            cell.btnInfo.addTarget(self, action: #selector(self.actionProductInfo(_:)), for: .touchUpInside)
//            cell.btnCart.addTarget(self, action: #selector(self.actionAddProduct(_:)), for: .touchUpInside)
//            if let products = viewModel.getCategory(atPos: selectedRow).products {
//                let product = products[section]
//                cell.lblProductName.text = product.productName
//                cell.lblProductSubText.text = product.productDescription
//                cell.lblPrice.text = "\(CURRENCY_SYMBOL)\(product.productPrice ?? 0)"
//                let imgUrl  = product.productImage ?? ""
//                cell.imgProduct.sd_setImage(with: URL(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "go_local_first"))
//            }
//            return cell
//        }
//        return UITableViewCell()
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        100
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCategoryTVCell", for: indexPath) as? SingleCategoryTVCell {
            cell.selectionStyle = .none
            cell.tag = indexPath.row
//            if let selectedProduct = viewModel.isItemAdded(categoryIndex: selectedRow, productIndex: indexPath.section, selectedIndex: indexPath.row) {
//                cell.lblProductCount.text = "\(selectedProduct.productQty )"
//                cell.lblProductDetails.text = (selectedProduct.option?.variationName ?? "") + " - " + "\(selectedProduct.selectedAddons.map({$0.addonName ?? ""}).joined(separator: " - "))"
//                cell.lblPrice.text = "\(CURRENCY_SYMBOL)\(selectedProduct.totalPrice)"
//            }
            
            cell.lblCategoryName.text = "Italian Food"
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func actionProductInfo(_ sender : UIButton){
//        let tag = sender.tag
////        let section = tag / 100
////        let row = tag % 100
//        if let products = viewModel.getCategory(atPos: selectedRow).products {
//            let vc =  ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
//            vc.product = products[tag]
//            self.productListViewController?.navigationController?.pushViewController(vc, animated: true)
//
//        }
    }
    @objc func actionAddProduct(_ sender : UIButton){
//        let tag = sender.tag
//        if let products = viewModel.getCategory(atPos: selectedRow).products {
//            let vc =  AddOnsListViewController(nibName: "AddOnsListViewController", bundle: nil)
//            vc.product = products[tag]
//            vc.setCompletion { (product) in
//                if let addedProduct = product {
//                    SELECTED_PRODUCTS_ARR.append(addedProduct)
//                    SELECTED_STORE_ID = self.productListViewController?.storeId ?? 0
//                    self.tableView.reloadData()
//                }
//            }
//            self.productListViewController?.navigationController?.pushViewController(vc, animated: true)
//
//        }
    }
}

//extension CategoryListViewDataSource : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.viewModel.getCategoriesRowCount()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleCategoryNameCVCell", for: indexPath) as? SingleCategoryNameCVCell{
//            let isselected = indexPath.row == selectedRow
//            let catObj = viewModel.getCategory(atPos: indexPath.item)
//
//            cell.viewBackground.backgroundColor = isselected ? GreenColor : .white
//            cell.viewBackground.layer.borderColor = isselected ? GreenCGColor : UIColor.gray.cgColor
//            cell.lblCategoryName.textColor = isselected ? .white : .black
//            cell.lblCategoryName.text = catObj.categoryName ?? ""
//
//            //cell.view
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if selectedRow != indexPath.row {
//            if let cell = collectionView.cellForItem(at: IndexPath(item: selectedRow, section: 0)) as? SingleCategoryNameCVCell {
//                cell.viewBackground.backgroundColor = .white
//                cell.viewBackground.layer.borderColor = UIColor.gray.cgColor
//                cell.lblCategoryName.textColor = .black
//            }
//            previousSelectedRow = self.selectedRow
//            selectedRow = indexPath.row
//            if let cell = collectionView.cellForItem(at: indexPath) as? SingleCategoryNameCVCell {
//                cell.viewBackground.backgroundColor = GreenColor
//                cell.viewBackground.layer.borderColor = GreenCGColor
//                cell.lblCategoryName.textColor = .white
//            }
//            //collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
//            scrollCategories()
//            tableView.reloadData()
//        }
//        //collectionView.reloadData()
//    }
//    func scrollCategories(){
//        let indexPath = IndexPath(row: selectedRow, section: 0)
//        self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
//    }
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: collectionView.bounds.width / CGFloat(10.0), height: collectionView.bounds.height - 10)
////    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//}
