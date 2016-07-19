//
//  ListViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/19.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var wholeArray: [AnyObject] = []
    
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
        
        
        cell.titleLabel.text = "TEST"
        cell.imageView.image = UIImage(named: "welcome.png")
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
        //TODO: これは1ではない
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
