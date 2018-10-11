//
//  ViewController.swift
//  PrivateProtocolAlert
//
//  Created by 曹冲 on 2018/10/11.
//  Copyright © 2018年 曹冲. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let contents = ["        我们深知个人信息对您的重要性，并会尽全力保护您的个人信息安全可靠。我们致力于维持您对我们的信任，恪守以下原则，保护您的个人信息：权责一致原则、目的明确原则、选择同意原则、最少够用原则、确保安全原则、主体参与原则、公开透明原则等。同时，我们承诺，我们将按业界成熟的安全标准，采取相应的安全保护措施来保护您的个人信息。","1.我们如何收集和使用您的个人信息。","2.我们如何共享、转让、公开披露您的个人信息。","3.我们如何使用 Cookie 和同类技术。","4.我们如何共享、转让、公开披露您的个人信息。"]
        PrivateAlertService.shared.show(with: contents, in: self, agreeCallback: {
            print("同意")
        }, disAgreeCallback: {
            print("不同意")
        }, userProCallback: {
            print("用户协议")
        }, privateProCallback: {
            print("隐私政策")
        })
        
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

