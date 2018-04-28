//
//  HomeController.swift
//  urcal
//
//  Created by Kilian Hiestermann on 12.05.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GeoFire

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, HomeControllerViewCellDelegate {
    
    func didTapComment(postID: String) {
        let layout = UICollectionViewFlowLayout()
        let commentsController = CommentsController(collectionViewLayout: layout, postID: postID)
        
        self.navigationController?.pushViewController(commentsController, animated: true)
    }
    
    
    let cellId = "cellId"
    var locality: String?{
        didSet{
            navigationItem.title = locality
        }
    }
    var userBookmarks = [String]()
    
    var posts = [UserPost]()
    
    let manager = CLLocationManager()
    
    var longitude: Double? = nil
    var latitude: Double? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        let oldDelegate = self.collectionView?.delegate
        DispatchQueue.main.async {
            self.collectionView?.delegate = oldDelegate
        }
        
        collectionView?.register(HomeControllerViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshContoll = UIRefreshControl()
        refreshContoll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshContoll
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name:.refreshHomeController, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowMap), name: .setUpMap, object: nil)
        
        if locality == nil {
            settingUpCLLocationManager()

        }
        
        setupNavBar()
        
        handleRefresh()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Range", style: .plain, target: self, action: #selector(showRangeSettings))
    }
    
    fileprivate func settingUpCLLocationManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startMonitoringSignificantLocationChanges()
    }
    
    func handleShowMap(notification: Notification){
        
        if let myDict = notification.object as? [String: Any]{
            if let longitude = myDict["longitude"] as? Double {
                if let latitude = myDict["latitude"] as? Double {
                    let popUpController = PopUpController()
                    popUpController.longitude = longitude
                    popUpController.latitude = latitude
                    popUpController.modalPresentationStyle = .overCurrentContext
                    present(popUpController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showRangeSettings() {
        let rangeSettingsController = RangeSettingsController()
        rangeSettingsController.modalPresentationStyle = .overCurrentContext
        present(rangeSettingsController, animated: true, completion: nil)
        
    }
    
    func handleRefresh (){
        posts.removeAll()
        userBookmarks.removeAll()
        collectionView?.reloadData()    
        fetchBookmarks()
        fetchLocalityPosts()    
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeControllerViewCell
        cell.userLatitude = manager.location?.coordinate.latitude
        cell.userLongitude = manager.location?.coordinate.longitude
        cell.delegate = self
        if userBookmarks.contains(posts[indexPath.item].post.postId){
            cell.bookmarked = true
        } else {
            cell.bookmarked = false
        }
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (view.frame.width / 2) + 118
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    fileprivate func fetchLocalityPosts(){
        
        guard let latitude = self.latitude else { return }
        guard let longitude = self.longitude else { return }
        
        let geofireRef = Database.database().reference().child("locality")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let center = CLLocation(latitude: latitude, longitude: longitude)
        
        let defaults = UserDefaults.standard
        var range = defaults.double(forKey: "range")
        if range == nil{ // Will be dismissed later standart range will be implemented
            range = 20.0
        }
        
        let circleQuery = geoFire?.query(at: center, withRadius: range)
        self.collectionView?.refreshControl?.endRefreshing()
        
         circleQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            Database.fetchPostWithId(postId: key, completion: { (post) in
                Database.fetchUserWithUid(uid: post.uid, completion: { (user) in
                   
                    let fetchdpost = UserPost(user: user, post: post)
                    self.posts.append(fetchdpost)
                    
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.post.creationDate.compare(p2.post.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                })
            })
        })

    }
    
    fileprivate func fetchBookmarks(){
        guard let uId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uId).child("bookmarks")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let postIdDictionary = snapshot.value as? [String: Any] else { return }
            postIdDictionary.forEach({ (key, value) in
                self.userBookmarks.append(key)
            })
        }) { (err) in
            print(err)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
       
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), completionHandler: {(placemarks, err) -> Void in
                                                
        if err != nil {
            print("Reverse geocoder failed with error" + err!.localizedDescription)
          return
        }
                                                
            if placemarks!.count > 0 {
                let pm = placemarks?[0].locality
                self.navigationItem.title = pm
                self.locality = pm
                manager.stopUpdatingLocation()
                
            }else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
}
