//
//  ViewController.swift
//  serverURL
//
//  Created by Bill Hu on 2017/6/16.
//  Copyright © 2017年 ifLab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40))
        view.addSubview(label)
        
        //存储url表
        let url = "https://api.iflab.org/api/v2/saerverurl/_table/"
        //获取真实URL
        label.text = HBServerURL.getWithURL(url, apikey: "c4c6a2a605c559a089f785394561919eecf2c548b631f3256678870f07691b50")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

