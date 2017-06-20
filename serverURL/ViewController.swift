//
//  ViewController.swift
//  serverURL
//
//  Created by Bill Hu on 2017/6/16.
//  Copyright © 2017年 ifLab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var getLabel: UILabel!
    let username = ""
    let password = ""
    let apikey = ""
    let tableurl = "https://api.iflab.org/api/v2/serverurl/_table/serverurl"
    let loginurl = "https://api.iflab.org/api/v2/user/session"
    let version = "3.6.2"
    let nickName = "Bistu云盘"
    let uploadURL = "https://api.iflab.org/api/v2/serverurl/_table/serverurl"
    let realURL = "https://panweb.bistu.edu.cn"

    @IBAction func getURL(_ sender: UIButton) {
        let s = HBServerURL.getWithVersion(version, appBundleID: nickName, url: uploadURL, apikey: apikey)
        if s == "https://www.example.com" {
            getLabel.text = "error"
        } else {
            getLabel.text = s
        }
    }
    
    @IBAction func sentURL(_ sender: UIButton) {
        let s = HBServerURL.setWithUsername(username, password: password, loginURL: loginurl, url: tableurl, apikey: apikey, version: version, nickName: nickName, realURL: realURL)
        if s == "https://www.example.com" {
            getLabel.text = "error"
        } else {
            getLabel.text = s
        }
    }
    
    @IBAction func editURL(_ sender: UIButton) {
        let s = HBServerURL.eidt(withUsername: username, password: password, loginURL: loginurl, url: tableurl, apikey: apikey, version: version, nickName: nickName, newRealURL: realURL)
        if s == "https://www.example.com" {
            getLabel.text = "error"
        } else {
            getLabel.text = s
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

