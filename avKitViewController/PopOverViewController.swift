//
//  PopOverViewController.swift
//  avKitViewController
//
//  Created by Luthfi Fathur Rahman on 6/15/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var text_URL: UITextField!
    @IBOutlet weak var btn_playMedia: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text_URL.delegate = self
        
        btn_playMedia.layer.cornerRadius = 5
        btn_playMedia.isEnabled = false
        btn_playMedia.backgroundColor = UIColor.gray
        
        let tapAnywhere: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(PopOverViewController.dismissKeyboard))
        view.addGestureRecognizer(tapAnywhere)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if !(text_URL.text?.isEmpty)! {
            text_URL.text = nil
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueOnlineMedia" {
            let destVC = segue.destination as! AVViewController
            destVC.selectedPath = URL(string: text_URL.text!)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)! {
            btn_playMedia.isEnabled = true
            btn_playMedia.backgroundColor = UIColor(red: 0, green: 126, blue: 127, alpha: 1.0)
        } else {
            btn_playMedia.isEnabled = false
            btn_playMedia.backgroundColor = UIColor.gray
        }
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
