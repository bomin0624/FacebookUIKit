//
//  MainController.swift
//  Facebook
//
//  Created by Bomin on 2020/2/28.
//  Copyright © 2020 Bomin Chuang. All rights reserved.
//


import UIKit
import LBTATools

class PostCell: LBTAListCell<String> {
    
    let imageView = UIImageView(image: UIImage(named: "avatar1"), contentMode: .scaleAspectFit)
    let nameLabel = UILabel(text: "BABYMETAL",font: .boldSystemFont(ofSize: 16))
    let dateLabel = UILabel(text: "Friday at 11:11AM",font: .boldSystemFont(ofSize: 12),textColor: .lightGray)
    let postTextLabel = UILabel(text: "   " + "BABYMETALは、日本の女性2人組メタルダンス・ユニット。通称「べビメタ」。" + "「アイドルとメタルの融合」をテーマに2010年結成。2014年から国外での活動が多くなっている")
    let photosGridController = PhotosGridController()
    
    override func setupViews() {
        backgroundColor = .white
        imageView.frame.size = CGSize(width: 100, height: 100)
        imageView.layer.cornerRadius = 25
        postTextLabel.numberOfLines = 2
        stack(hstack(imageView.withHeight(50).withWidth(50),
                     stack(nameLabel, dateLabel),
            spacing: 8).padLeft(12).padRight(12).padTop(12),
              postTextLabel,
              photosGridController.view,
              spacing: 8)
       
    }
}

class StoryHeader: UICollectionReusableView {
    
    let storiesController = StoriesController(scrollDirection: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        stack(storiesController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

class StoryPhotoCell: LBTAListCell<String> {
    
    override var item: String! {
        didSet {
            imageView.image = UIImage(named: item)
        }
    }
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "BABYMETAL", font: .boldSystemFont(ofSize: 12), textColor: .white)
    
    
    override func setupViews() {
        imageView.layer.cornerRadius = 10
        
        stack(imageView)
        
        setupGradientLayer()
        
        stack(UIView(), nameLabel).withMargins(.allSides(8))
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.1]
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
}

class StoriesController: LBTAListController<StoryPhotoCell, String>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height - 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = ["photo1", "avatar1", "story_photo1", "story_photo2", "avatar1"]
    }
    
}

class MainController: LBTAListHeaderController<PostCell, String, StoryHeader>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1)
        
        self.items = ["hello", "WORLD", "1", "3"]
        
        setupNavBar()
        //searchButton.layer.cornerRadius = 40
    }
    
    let fbLogoImageView = UIImageView(image: UIImage(named: "fb_logo"), contentMode: .scaleAspectFit)
    let searchButton = UIButton(image: UIImage(named: "search")!, tintColor: .black)
    //let searchButton = UIButton(title: "Search", titleColor: .black)

    
    fileprivate func setupNavBar() {
        let coverWhiteView = UIView(backgroundColor: .white)
        view.addSubview(coverWhiteView)
        coverWhiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        coverWhiteView.constrainHeight(safeAreaTop)
        
        
        let width = view.frame.width - 120 - 16 - 30
        
        let titleView = UIView(backgroundColor: .clear)
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
        
       
        
        titleView.hstack(fbLogoImageView.withWidth(120), UIView(backgroundColor: .clear).withWidth(width),
                         searchButton.withWidth(30))
        
        navigationItem.titleView = titleView
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        
        let magicalSafeAreaTop: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        print(scrollView.contentOffset.y)
        
        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        
        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y + magicalSafeAreaTop) / magicalSafeAreaTop)
        
        [fbLogoImageView, searchButton].forEach{$0.alpha = alpha}
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 400)
    }
}


import SwiftUI
struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return UINavigationController(rootViewController: MainController())
        }
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
}
