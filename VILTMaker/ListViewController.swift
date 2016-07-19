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
            let realm = try Realm()
            return realm.objects(Question)
        }catch{
            print("エラー")
        }
        return nil
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! QuestionCollectionViewCell
        
        
        let list = ListItems?[indexPath.row]
        
        
        cell.titleLabel.text = list?.name
        cell.imageView.image = UIImage(data: (list?.image)!)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListItems?.count ?? 0
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
