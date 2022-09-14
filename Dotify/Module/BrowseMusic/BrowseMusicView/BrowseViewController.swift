//
//  BrowseViewController.swift
//  Dotify
//
//  Created by user on 7/16/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase
class BrowseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{
    var parentVC: MiniPlayerViewController?
    // declare entity structures and FIRDatabase reference
    var topHitCollectionList = [BrowseTopHitCollection]()
    var featuredAlbumList = [featuredAlbums]()
    var genresMoodList = [genresMoods]()
    var refFeaturedAlbum: DatabaseReference!
    var refTopHitCollection: DatabaseReference!
    var refGenresMood: DatabaseReference!
    // UI elements
    //  Browse Label
    @IBOutlet weak var testLabel: UILabel!
    // Whole view stack and scroll
    @IBOutlet weak var browseStack: UIStackView!
    @IBOutlet weak var browseScrollView: UIScrollView!
    // First part of stack
    @IBOutlet weak var topHitCollection: UIView!
    @IBOutlet weak var topHitCollectionView: UICollectionView!
    // Second part of stack
    @IBOutlet weak var featuredAlbum: UIView!
    @IBOutlet weak var featuredAlbumView: UITableView!
    
    // Third part of stack
    @IBOutlet weak var genresMood: UIView!
    @IBOutlet weak var genresMoodCollectionView: UICollectionView!
    
    // cell identifier
    let cellIdentifier1 = "cellIdentifier1"
    let cellIdentifier2 = "cellIdentifier2"
    let cellIdentifier3 = "cellIdentifier3"
    
    
    // setup tableview and collection views
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuredAlbumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier3, for: indexPath) as! FeaturedAlbumTableViewCell
        let album: featuredAlbums
        album = featuredAlbumList[indexPath.row]
        cell.featuredAlbumTitle.text = album.title
        cell.featuredAlbumArtist.text = album.artist
        cell.featuredAlbumSongCount.text = album.songCount
        cell.featuredAlbumImage.sd_setImage(with: URL(string: album.imageUrl ?? "" ), placeholderImage: #imageLiteral(resourceName: "library"))
        return cell
    }
    
    // collection views
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topHitCollectionView {
            return topHitCollectionList.count
        }
        if collectionView == genresMoodCollectionView {
            return genresMoodList.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topHitCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier1, for: indexPath) as! BrowseCollectionViewCell
            // tophit
            cell.browseCollectionName.sizeToFit()
            cell.browseCollectionLabel.sizeToFit()
            let topHitCollection: BrowseTopHitCollection
            topHitCollection = topHitCollectionList[indexPath.row]
            cell.browseCollectionName.text = topHitCollection.name
            cell.browseCollectionLabel.text = topHitCollection.label
            cell.browseCollectionImage.sd_setImage(with: URL(string: topHitCollection.imageUrl!), completed: nil)
            return cell
        }
        
        if collectionView == genresMoodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! GenresMoodCollectionViewCell
            
            let genresMoodCollection: genresMoods
            genresMoodCollection = genresMoodList[indexPath.row]
            cell.genresMoodName.text = genresMoodCollection.name
            cell.genresMoodImage.sd_setImage(with: URL(string: genresMoodCollection.imageUrl!), completed: nil)
            cell.genresMoodLabel.sd_setImage(with: URL(string: genresMoodCollection.labelUrl!), completed: nil)
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topHitCollectionView {
            return CGSize(width: 140, height: 175)
        }
        if collectionView == genresMoodCollectionView {
            return CGSize(width: 150, height: 185)
        }
        return CGSize()
    }
    // viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "thumbBlur")!)
        // Do any additional setup after loading the view.
        // top hit
        refTopHitCollection = Database.database().reference().child("browseTopHitCollection")
        refTopHitCollection.observe(DataEventType.value, with: { (DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                self.topHitCollectionList.removeAll()
                for topHitCollectionsList in DataSnapshot.children.allObjects as! [DataSnapshot] {
                    let topHitCollectionObject = topHitCollectionsList.value as? [String: AnyObject]
                    let topHitCollectionLabel = topHitCollectionObject?["label"]
                    let topHitCollectionName = topHitCollectionObject?["name"]
                    let topHitCollectionImageUrl = topHitCollectionObject?["imageUrl"]
                    let topHitCollectionInThatCell = BrowseTopHitCollection(label: topHitCollectionLabel as! String?, name: topHitCollectionName as! String?, imageUrl: topHitCollectionImageUrl as! String?)
                    self.topHitCollectionList.append(topHitCollectionInThatCell)
                }
                self.topHitCollectionView.reloadData()
            }
        })
        
        
        
        //test: firebase method
        // note: successfully update String-related data from firebase up to screen (only for featured album for now, the rest would be the same)
        // MARK: TODO
        // re-organize and clean up code (it's a mess)
        // obj: find a way to upload image as album and playlist images (Alamofire?) DONE
        // obj: find a way to translate artist_id to real artist name (which is located in different tree in Firebase)
        // obj: fix scrolling bug in featuredAlbumView
        // obj: make images in collection view dimmer
        
        
        // featured album
        refFeaturedAlbum = Database.database().reference().child("albums")
        refFeaturedAlbum.observe(DataEventType.value, with: { (DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                self.featuredAlbumList.removeAll()
                for featuredAlbumsList in DataSnapshot.children.allObjects as! [DataSnapshot] {
                    
                    let featuredAlbumObject = featuredAlbumsList.value as? [String: AnyObject]
                    let featuredAlbumTitle = featuredAlbumObject?["name"]
                    let featuredAlbumArtist = featuredAlbumObject?["artist_id"]
                    let featuredAlbumSongCount = featuredAlbumObject?["songCount"]
                   let featuredAlbumImageUrl = featuredAlbumObject?["imageUrl"]
                    
                   
                    // featuredAlbumImage.sd_setImage(with: featuredAlbumImageURL)

                    
                    //let featuredAlbumId = featuredAlbumObject?[""]
                    let featuredAlbumInThatCell = featuredAlbums(id: nil, title: featuredAlbumTitle as! String?, artist: featuredAlbumArtist as! String?, songCount: featuredAlbumSongCount as! String?, imageUrl: featuredAlbumImageUrl as! String?)
                    self.featuredAlbumList.append(featuredAlbumInThatCell)
                }
                self.featuredAlbumView.reloadData()
            }
            
        })
        
        // genres mood
        refGenresMood = Database.database().reference().child("genres")
        refGenresMood.observe(DataEventType.value, with: {(DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                self.genresMoodList.removeAll()
                for genresMoodsList in DataSnapshot.children.allObjects as! [DataSnapshot] {
                    let genresMoodObject = genresMoodsList.value as? [String: AnyObject]
                    let genresMoodName = genresMoodObject?["name"]
                    let genresMoodLabelUrl = genresMoodObject?["labelUrl"]
                    let genresMoodImageUrl = genresMoodObject?["imageUrl"]
                    
                    let genresMoodInThatCell = genresMoods(id: nil, name: genresMoodName as! String?, labelUrl: genresMoodLabelUrl as! String?, imageUrl: genresMoodImageUrl as! String?)
                    self.genresMoodList.append(genresMoodInThatCell)
                }
                self.genresMoodCollectionView.reloadData()
            }
        })
        
        // MARK: NIB REGISTER
        // top hit
        self.topHitCollectionView.register(UINib(nibName: "BrowseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier1)
        topHitCollectionView.delegate = self
        topHitCollectionView.dataSource = self
        topHitCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        topHitCollectionListAction()
        
        // featured album
        self.featuredAlbumView.register(UINib(nibName: "FeaturedAlbumTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier3)
        featuredAlbumView.delegate = self
        featuredAlbumView.dataSource = self
        featuredAlbumListAction()
        
        // genres mood
        self.genresMoodCollectionView.register(UINib(nibName: "GenresMoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        genresMoodCollectionView.delegate = self
        genresMoodCollectionView.dataSource = self
        genresMoodCollectionView.contentInset = UIEdgeInsets( top: 0, left: 5, bottom: 0, right: 0)
        genresMoodListAction()

    }
    private func topHitCollectionListAction() {
        //MARK: IMPLEMENT LATER
    }
    
    private func featuredAlbumListAction() {
        
    }
    
    private func genresMoodListAction() {
        
    }
    /*
     // MARK: - Navigation
    
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // display Dotify icon
        let image: UIImage = UIImage(named: "icon")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        self.view.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        // hide upper navigation bar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        // search logo
        let rightLogo = UIBarButtonItem(image: UIImage (named: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchButton))
        self.navigationItem.rightBarButtonItem = rightLogo
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        
        // hamburger slide logo
        let leftLogo = UIBarButtonItem(image: UIImage (named: "ic_hamburger_menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(hamburgerMenuButton))
        self.navigationItem.leftBarButtonItem = leftLogo
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc private func hamburgerMenuButton() {
        //MARK: IMPLEMENT LATER
        parentVC?.toggleHamburgerView()
    }
    
    @objc private func searchButton() {
        print("press search")
        let searchVC = UINavigationController(rootViewController: SearchRouter.createModule(miniPlayer: parentVC))
        parentVC?.present(searchVC, animated: false, completion: nil)
    }
}

