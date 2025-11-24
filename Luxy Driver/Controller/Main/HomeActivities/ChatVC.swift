//
//  ChatVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 24/07/23.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var chatTblVw: UITableView!
    @IBOutlet weak var btnSendOt: UIButton!
    
    var arrMsgs: [ResChat] = []
    var receiverId = ""
    var requestId = ""
    var userName = ""
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtMessage.addHint("Write here")
        self.chatTblVw.register(UINib(nibName: "RightCell", bundle: nil), forCellReuseIdentifier: "RightCell")
        self.chatTblVw.register(UINib(nibName: "LeftCell", bundle: nil), forCellReuseIdentifier: "LeftCell")
        
        if #available(iOS 10.0, *) {
            self.chatTblVw.refreshControl = refreshControl
        } else {
            self.chatTblVw.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.getChat), for: .valueChanged)
        self.getChat()
        NotificationCenter.default.addObserver(self, selector: #selector(ShowRequest), name: Notification.Name("NewMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: self.userName, CenterImage: "", RightTitle: "", RightImage: "ChatCall", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func ShowRequest (notification:NSNotification) {
        if let Dic = notification.object as? NSDictionary {
            print(Dic)
            self.getChat()
        }
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        if txtMessage.text == "Write Here" || txtMessage.text.count == 0 {
            self.alert(alertmessage: "Please Enter message")
        } else {
            self.sendChat()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //            bottomConst.constant = (keyboardSize.height) * -1.0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            //            bottomConst.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatVC {
    
    @objc func getChat() {
        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"] = self.receiverId as AnyObject

        print(paramDict)
        
        Api.shared.getChat(self, paramDict) { (response) in
            if response.count > 0 {
                self.arrMsgs = response
            } else {
                self.arrMsgs = []
            }
            self.chatTblVw.reloadData()
        }
    }
    
    func sendChat() {
        var paramDict : [String:String] = [:]
        paramDict["receiver_id"] = receiverId
        paramDict["sender_id"] =  k.userDefault.value(forKey: k.session.userId) as? String
        paramDict["request_id"] = self.requestId
        paramDict["type"] = "NORMAL"
        paramDict["chat_message"] = self.txtMessage.text!
        paramDict["timezone"] = localTimeZoneIdentifier
        paramDict["date_time"] = Utility.getCurrentTime()

        print(paramDict)
        
        Api.shared.sendChat(self, paramDict, images: [:], videos: [:]) { (response) in
            self.txtMessage.text = ""
            self.view.endEditing(true)
            self.getChat()
        }
    }
}

extension ChatVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMsgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.arrMsgs[indexPath.row]
        
        if let checkId = k.userDefault.value(forKey: k.session.userId) as? String, checkId == obj.sender_id
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightCell", for: indexPath) as! RightCell
            cell.textMessage.text = obj.last_message ?? ""
            cell.lblDateAndTime.text = obj.date_time ?? ""
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftCell", for: indexPath) as! LeftCell
            cell.textMessage.text = obj.last_message ?? ""
            cell.lblDateAndTime.text = obj.date_time ?? ""
            return cell
        }
    }
    
//    func scrollToBottom(){
//        DispatchQueue.main.async {
//            if self.arrMsgs.count > 0 {
//                let indexPath = IndexPath(row: self.arrMsgs.count-1, section: 0)
//                self.chatTblVw.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//        }
//    }
}

extension ChatVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtMessage {
            if txtMessage.textColor == UIColor.white && txtMessage.text.count != 0 {
                txtMessage.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtMessage {
            if txtMessage.text.count == 0 {
                txtMessage.text = "Send Message"
            }
        }
    }
}
