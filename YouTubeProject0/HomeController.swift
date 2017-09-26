//
//  ViewController.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 19..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit



class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    //FeedCellDelegate로 네비게이션 숨기는 거 구현하는 부분 아직 매끄럽지 못한데 일단 진도 나가야되니까 Class에 FeedCellDelegate 채택하고
//    func swipeUpNavBar() {
////        view.addSubview(redView)
////        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
////        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
//        
//
//        UIView.animate(withDuration: 0.2) {
//            self.navigationController?.barHideOnSwipeGestureRecognizer
//            
//            self.navigationController?.isNavigationBarHidden = true
//        }
//    }
//    func swipeDownNavBar() {
////        view.addSubview(redView)
////        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
////        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
//        
//        UIView.animate(withDuration: 0.2) {
//            
//            self.navigationController?.isNavigationBarHidden = false
//        }
//    }
    
    
    let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    let titles = ["Home","Trending","Subscriptions","Account"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.bounces = false
        
        
//        navigationItem.title = "  Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titlelabel.text = "  Home"
        titlelabel.textColor = UIColor.white
        titlelabel.font = UIFont.systemFont(ofSize: 20)
        
        navigationItem.titleView = titlelabel


        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    func setupCollectionView()
    {
        
        //appdelegate 부분에서 collectionViewLayout 추가 했기 때문에 값 들어옴.
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.white
        
//        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        
        //메뉴바 크기만큼 내린 거
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        //이거 스크롤 했을 때 페이징 되는 거. 그러니까 페이지 두개가 걸쳐서 보이는거 막는 거.
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavBarButtons()
    {
        
        let btn1 = UIButton()
        btn1.tintColor = UIColor.white
        btn1.setImage(UIImage(named: "more5")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        btn1.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        
        let btn2 = UIButton()
        btn2.tintColor = UIColor.white
        btn2.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        let item2 = UIBarButtonItem()
        item2.customView = btn2
        
        //밑에가 원래 했던 코드 안먹는다 이거
        
//        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
////        searchImage.
//        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handelSearch))
////        searchBarButtonItem.tintColor = UIColor.white
//        let moreImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
//        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handelMore))
//        moreBarButtonItem.tintColor = UIColor.white
        
//        navigationItem.rightBarButtonItems = [moreBarButtonItem,searchBarButtonItem]
        navigationItem.rightBarButtonItems = [item1, item2]
        
        
    }
    
    lazy var settingLauncher: SettingLauncher =
    {
        let launcher = SettingLauncher()
        launcher.homeController = self
        return launcher
    }()

    func handleMore()
    {
        //이 밑에처럼 쓰면 누를때마다 self로 알려줘야되니까 이럴 때 lazy var를 쓴다. settingLauncher.showSettings() 이게 호출될 때 settingLauncher 가 nil이면 한번 불리고 이후에는 nil이 아니니까 불리지 않는다.
        //settingLauncher.homeController = self
        
        // 와 미친.. 이 밑에 코드 여기다 직접 썼을 땐 네비게이션 바랑 그 위에 까맣게 안됐다 클래스로 따로 빼서 밑에 코드처럼 하니까 전체 화면 꺼매짐 대박!
        //if let window = UIApplication.shared.keyWindow{ blackView.frame = window.frame }
        settingLauncher.showSettings()
        
//        showControllerForSettings()
        
    }
    
    func showControllerForSetting(setting:Setting)
    {
        let dummySettingViewController = UIViewController()
        
        dummySettingViewController.view.backgroundColor = UIColor.white
        dummySettingViewController.navigationItem.title = setting.name.rawValue
        
        //push하면 자동으로 생기는 이전 화면으로 돌아가는 왼쪽에 생기는 <Home 버튼 칼라 바꾸기
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //titleColor 바꾸기
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.pushViewController(dummySettingViewController, animated: true)
    }
    
//    func handleDismiss()
//    {
//        settingLauncher.handleDismiss()
//    }
    
    
    
    func handleSearch()
    {
        scrollToMenuIndex(menuIndex: 2)
    }
    
    func scrollToMenuIndex(menuIndex: Int)
    {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
        setTitleForIndex(index: menuIndex)
        
    }
    private func setTitleForIndex(index:Int)
    {
        if let titleLabel = navigationItem.titleView as? UILabel
        {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    lazy var menuBar: MenuBar =
    {
        let mb = MenuBar()
        //밑에 줄 떄문에 lazy var 쓴다
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar()
    {
        
        // 대박 1.위아래로 스와이프하면 네이베이션바가 생겼다 사라졌다 한다. 근데 메뉴바가 쪼금 가림. 요거 해결하려고 2번으로 감. menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true 씀
//        navigationController?.hidesBarsOnSwipe = true
//        navigationController?.isNavigationBarHidden
        
        //3. 이게 마지막
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        //요기까지
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        
        //2. 이 코드로 쪼금 가리는 메뉴바 해결 근데 뒤에 공간같은거 살짝 생김. 요거 해결하려고 3번 코드 씀
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    //스크롤 했을 때 메뉴 바 밑에 스크롤 되는 horizontalBarView 움직이는 거
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    //드래그 끝났을 때 메뉴바 셀렉 되는 거 바꾸는 거
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        let index = targetContentOffset.move().x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: 0))
        
        setTitleForIndex(index: Int(index))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier:String
        
        if indexPath.item == 1
        {
            identifier = trendingCellId
            
        }else if indexPath.item == 2
        {
            identifier = subscriptionCellId
            
        }else
        {
            identifier = cellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        cell.delegate = self

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }

}




