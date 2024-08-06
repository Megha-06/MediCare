//
//  ProductCategoriesVC.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import UIKit
import ImageSlideshow

class ProductCategoriesVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionCateories: UICollectionView!
    @IBOutlet weak var viewSlider: ImageSlideshow!
    
    // MARK: - Variables
    private var viewModel = ProductViewModel()
    var arrBannerImage = ["productOne","productOne","productOne","productOne","productOne"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}
extension ProductCategoriesVC{
    func configuration() {
        collectionCateories.register(UINib.init(nibName: "ProductCategoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCategoryCollectionCell")
        viewSlider.slideshowInterval = 5.0
        viewSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        viewSlider.contentScaleMode = UIViewContentMode.scaleAspectFill
        viewSlider.activityIndicator = DefaultActivityIndicator()
        viewSlider.setImageInputs([
            ImageSource(image: UIImage(named: "productOne")!),
            ImageSource(image: UIImage(named: "productTwo")!),
            ImageSource(image: UIImage(named: "productThree")!),
            ImageSource(image: UIImage(named: "productFour")!),
            ImageSource(image: UIImage(named: "productFive")!),
        ])
        viewSlider.layer.cornerRadius = 12
        initViewModel()
        observeEvent()
    }
    
    func initViewModel() {
        viewModel.fetchProducts()
    }
    
    // Data binding event observe  - communication
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loading:
                // Indicator show
                self.showActivityIndicator()
                print("Product loading....")
            case .stopLoading:
                // Indicator hide
                print("Stop loading...")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    // UI Main works well
                    self.collectionCateories.reloadData()
                }
            case .error(let error):
                print(error)
            case .ProductList(product: let product):
                print("")
            }
        }
    }
}

// MARK: - CollectionView DataSource & Delegate

extension ProductCategoriesVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products?.response.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCollectionCell", for: indexPath as IndexPath) as! ProductCategoryCollectionCell
        let dict = viewModel.products?.response[indexPath.row]
        if let categoryName = dict?.category_name{
            cell.lblCategory.text = categoryName
        }
        cell.onSelectSeeAll = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductListingVC") as! ProductListingVC
            vc.selectedCategory = dict?.category_name
            vc.selectedCategoryId = dict?.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (UIScreen.main.bounds.width - space) / 2.1
        return CGSize(width: size, height: 257)
    }
}
