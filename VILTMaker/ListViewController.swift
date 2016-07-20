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
            
            let realm = try Realm()
            return realm.objects(Question)
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
        listCollectionView.registerNib(UINib(nibName: "QuestionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        listCollectionView.reloadData()
    }
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! QuestionCollectionViewCell
        
        
        let list = ListItems?[indexPath.row]
        
        
        cell.titleLabel.text = list?.name
        cell.imageView.image = UIImage(data: (list?.image)!)
        let df = NSDateFormatter()
        df.dateFormat = "MM/dd HH:mm"
        cell.timeLabel.text = df.stringFromDate((list?.makingDate)!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let list = ListItems?[indexPath.row]
        uuid = (list?.id)!
        NSUserDefaults.standardUserDefaults().setObject(uuid, forKey: "uuid")
        performSegueWithIdentifier("QuestionView", sender: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListItems?.count ?? 0
    }
    


    

}
