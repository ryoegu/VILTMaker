//
//  ListViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/19.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ListItems:Results<Question>?{
        do{
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {}
            })
            Realm.Configuration.defaultConfiguration = config
            
            
            var url: String!
            
            if let address = KeyManager().getValue("AWSRealmServerAddress") as? String {
                url = address
            }
            
            let syncServerURL = URL(string: "\(url!)~/Question")!
            let user = SyncUser.current!
            let configuration = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
            //一覧画面からアクセスした場合
            let realm = try! Realm(configuration: configuration)
                    
            return realm.objects(Question.self)
        }catch let error as NSError{
            print("error === %@",error)
        }
        return nil
    }
    var uuid: String = ""
    
    @IBOutlet var listCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = self
        listCollectionView.register(UINib(nibName: "QuestionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listCollectionView.reloadData()
    }
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! QuestionCollectionViewCell
        
        
        let list = ListItems?[indexPath.row]
        
        
        cell.titleLabel.text = list?.name
        cell.imageView.image = UIImage(data: (list?.image)!)
        let df = DateFormatter()
        df.dateFormat = "MM/dd HH:mm"
        cell.timeLabel.text = df.string(from: (list?.makingDate)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list = ListItems?[indexPath.row]
        uuid = (list?.id)!
        UserDefaults.standard.set(uuid, forKey: "uuid")
        performSegue(withIdentifier: "QuestionView", sender: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListItems?.count ?? 0
    }
    


    

}
