//
//  ViewController.swift
//  Swift_AuthenticationTest
//
//  Created by 麻生 拓弥 on 2015/02/27.
//  Copyright (c) 2015年 麻生 拓弥. All rights reserved.
//

import UIKit
import LocalAuthentication //追加

class ViewController: UIViewController {

    // StoryBoard と紐つけ
    @IBOutlet weak var authenticationBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        
    }

    // 認証ボタンが押されたら，Touch ID or Passcode or Cancel を選ばせる ActionSheet を表示させる
    @IBAction func authenticationAction(sender: AnyObject) {
        
        // ActionSheet 形式でコントローラ生成
        let alertController = UIAlertController(title: "Authentication",
            message: "Please choose Touch ID or Passcode",
            preferredStyle: .ActionSheet)
        
        // Touch ID 部分実装
        let touchidAction = UIAlertAction(title: "Touch ID", style: .Default,
            handler: {action in
                self.touchid_func() //Touch ID での処理関数へ
        })
        
        // Passcode 部分実装
        let passcodeAction = UIAlertAction(title: "Passcode", style: .Default,
            handler: {action in
                self.passcode_func() //Passcode での処理関数へ
        })
        
        // Cancel 部分実装
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,
            handler: nil)
        
        // コントローラにそれぞれのアクション追加
        alertController.addAction(touchidAction)
        alertController.addAction(passcodeAction)
        alertController.addAction(cancelAction)
        
        // ActionSheet に表示させる
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // ActionSheet で Touch ID を選択した場合呼ばれる
    func touchid_func() {
        
        // こちらもほぼテンプレ通り
        let context = LAContext()
        var error : NSError?
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(
                LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authentication Test (Touch ID)",
                reply: {
                    success, error in
                    if (success) {
                        
                        self.resultLabel.text = "SUCCESS"   // 指紋認証成功
                        
                    } else {
                        
                        self.resultLabel.text = "FAILED"    // 指紋認証失敗
                    }
            })
            
        } else {
            // Touch ID が使えないときまたは非搭載
            resultLabel.text = "Your device doesn't support Touch ID."
            
        }
    }
    
    // ActionSheet で Passcode を選択したときに呼ばれる
    func passcode_func() {
        
        var login_id: UITextField?
        var pass: UITextField?

        // Alert 形式でコントローラ生成
        let alertController = UIAlertController(title: "Authentication Test",
            message: "Please input your login ID and Password.",
            preferredStyle: .Alert)
        
        // Login 部分実装
        let loginAction = UIAlertAction(title: "Login", style: .Default,
            handler: {action in
                self.compare_func(login_id!.text, pass: pass!.text) //Touch ID での処理関数へ
        })
        
        // Cancel 部分実装
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,
            handler: nil)
        
        // コントローラにアクションを追加
        alertController.addAction(cancelAction)
        alertController.addAction(loginAction)
        
        // Alert に テキストフィールド(LOGIN)を追加
        alertController.addTextFieldWithConfigurationHandler({(textField:UITextField!) -> Void in
            
            login_id = textField
            textField.placeholder = "Your ID"
            
        })
        
        // Alert にテキストフィールド(PASSWORD)を追加
        alertController.addTextFieldWithConfigurationHandler({(textField:UITextField!) -> Void in
            
            pass = textField
            textField.placeholder = "Your password"
            textField.secureTextEntry = true
            
        })
        
        // Alert に表示させる
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // Passcode を選択し，実際に入力して Login ボタンを押すと呼ばれる
    func compare_func(loginid: String, pass: String) {
        
        println(loginid, pass)  // 確認用
        
        // 認証の正解を書いておく。普通はこんなところにはない。
        let correct_loginid = "milanista"
        let correct_passwd = "milan"
        
        // 2 つの引数と正解を比較して合っていれば SUCCESS，違っていれば FAIlED を表示
        if (loginid == correct_loginid && pass == correct_passwd) {
            
            resultLabel.text = "SUCCESS"
            
        } else {
            
            resultLabel.text = "FAILED"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}