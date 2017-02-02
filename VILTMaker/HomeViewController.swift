//
//  HomeViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2017/02/02.
//  Copyright © 2017年 Ryo Eguchi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
    }
    
    func updateLabel(){
        if let text = UserDefaults.standard.string(forKey: "name") {
            if text == "" {
                welcomeLabel.text = "名前を入力してください"
            }else{
                welcomeLabel.text = "こんにちは、\(text)さん"
            }
            
        }else{
            welcomeLabel.text = "名前を入力してください"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setNameButton(_ sender: Any) {
        let myAlert: UIAlertController = UIAlertController(title: "名前", message: "名前を入力してください", preferredStyle: .alert)
        
        
        
        let okButton = UIAlertAction(title: "決定", style: UIAlertActionStyle.default) { (action) in
            let textFields = myAlert.textFields as Array<UITextField>?
            if textFields != nil {
                for textField:UITextField in textFields! {
                    //テキストにアクセス
                    UserDefaults.standard.set(textField.text, forKey: "name")
                }
                self.updateLabel()
            }
        }
        myAlert.addTextField { (textField) in
            
        }
        myAlert.addAction(okButton)
        
        present(myAlert, animated: true, completion: nil)
        

    }

}
