//
//  ViewController.swift
//  Tweeter
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ViewController: BaseController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chatboxContainerView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var chatboxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatboxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    
    fileprivate var viewModel: MessageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerKeyboardNotifications()
        setupView()
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchMessages()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        deregisterKeyboardNotifications()
    }

    @IBAction func sendButtonTapped(_ sender: Any) {
        
        saveMessage()
        resetChatView()
    }
}
extension ViewController{
    func setupView(){
        self.title = "Tweeter"
        viewModel = MessageViewModel { [unowned self] (state) in
            switch state.editingStyle {
            case .none:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    self.tableView .setContentOffset(CGPoint(x:0,y:CGFloat.greatestFiniteMagnitude), animated: true)
                }
               
                
            case .insert(_):
                self.tableView.beginUpdates()
                let indexPath = IndexPath(item: self.tableView.numberOfRows(inSection: 0), section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                if (self.viewModel?.state.messages.count)! > 0 {
                    self.tableView.scrollToRow(at: IndexPath(item:(self.viewModel?.state.messages.count)! - 1, section: 0), at: .bottom, animated: true)
                }
            case let .delete(indexPath):
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func tapOnTable(gesture:UIGestureRecognizer){
        self.messageTextView.resignFirstResponder()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo{
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let height = keyboardSize.height
                
                self.chatboxBottomConstraint.constant = height
                
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
                
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo{
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            
            self.chatboxBottomConstraint.constant = 0
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
            
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.messageTextView.resignFirstResponder()
    }
}

extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (viewModel?.numberOfItemsToDisplay(in: section))!
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as! MessageViewCell
        
        if let message = viewModel?.message(at: indexPath){
            cell.configureCell(message: message)
        }
        
        return cell
    }
    func textViewDidChange(_ textView: UITextView) {
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
extension ViewController{
    func saveMessage(){
        guard let content = self.messageTextView.text else{
            return
        }
        do{
            let messageArray = try splitMessage(message: content)
            var index = (viewModel?.numberOfItemsToDisplay(in: 0))! + 1
            for message in messageArray{
                let newMessage = CoredataService.shared().addNewMessage(content:message, order: index)
                viewModel?.addNewMessage(message: newMessage)
                index += 1
            }
            CoredataService.shared().save()
        }catch MessageError.invalidLength{
            showErrorMessage(message: ErrorMesages.messageMaxLength.rawValue)
        }catch{
            showErrorMessage(message: ErrorMesages.unknow.rawValue)

        }
      
    }
}

