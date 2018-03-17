//
//  ViewController.swift
//  Tweeter
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chatboxContainerView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var chatboxBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatboxHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
        registerKeyboardNotifications()
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        deregisterKeyboardNotifications()
    }

    @IBAction func sendButtonTapped(_ sender: Any) {
        
        
        resetChatView()
    }
}
extension ViewController{
    func setupView(){
        self.title = NSLocalizedString("title_screen_main", comment: "")
        
        /**/
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        self.tableView.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "MessageViewCell")
        
        //
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnTable(gesture:)))
        self.tableView .addGestureRecognizer(tap)
        /**/
        self.messageTextView.delegate = self
    }
    
    func registerKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func tapOnTable(gesture:UIGestureRecognizer){
        self.messageTextView.resignFirstResponder()
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo{
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let height = keyboardSize.height
                if self.chatboxBottomConstraint.constant < height{
                    //willshow
                    self.chatboxBottomConstraint.constant = height
                }else{
                    //willHide
                    self.chatboxBottomConstraint.constant = 0
                    
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
                
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.messageTextView.resignFirstResponder()
    }
}

extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath)
        
        
        return cell
    }
    func textViewDidChange(_ textView: UITextView) {
        // Do the logic you want to happen everytime the textView changes
        // if string is == "do it" etc....
        let numberOfLine = self.messageTextView.numberOfLines()
        if numberOfLine > 5 {
            self.messageTextView.isScrollEnabled = true
        }else{
            self.messageTextView.isScrollEnabled = false
        }
    }
    func resetChatView(){
        self.messageTextView.text = ""
        self.messageHeightConstraint.constant = 40.0
        self.chatboxHeightConstraint.constant = 60.0
        UIView.animate(withDuration: 0.5) {
            self.view.updateConstraintsIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
}

