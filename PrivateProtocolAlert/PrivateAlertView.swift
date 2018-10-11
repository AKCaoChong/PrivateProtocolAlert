//
//  PrivateAlertView.swift
//  BaonahaoSchool
//
//  Created by 曹冲 on 2018/10/11.
//  Copyright © 2018年 XiaoHeTechnology. All rights reserved.
//

import UIKit
import YYText
import SnapKit

let kw = UIScreen.main.bounds.width
let kh = UIScreen.main.bounds.height

func realWidth(width: CGFloat) -> CGFloat {
    return (kw/375) * width
}

class PrivateAlertService: NSObject {
    
    static let shared = PrivateAlertService()

    var maskrView = UIView()
    var privateAlertView = PrivateAlertView()
    
    func show(with contents: [String], in viewController: UIViewController, agreeCallback: @escaping()->Void,disAgreeCallback: @escaping()->Void,userProCallback: @escaping()->Void,privateProCallback: @escaping()->Void) {
        let keyWindow = viewController.view.window
        let maskView = UIView()
        self.maskrView = maskView
        keyWindow?.addSubview(maskView)
        maskView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(keyWindow!)
        }
        maskView.layoutIfNeeded()
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskViewTapAction(tap:)))
        maskView.addGestureRecognizer(tap)
        let privateView = PrivateAlertView(frame: CGRect.zero, contents: contents)
        viewController.view.window?.addSubview(privateView)
        self.privateAlertView = privateView
        privateAlertView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(kw - 60)
            make.height.equalTo(realWidth(width: 400))
        }
        privateAlertView.layer.cornerRadius = 5
        privateAlertView.layer.masksToBounds = true
        self.animationWithView(view: privateAlertView, duration: 0.5)
        privateView.agreeCallBack = {
            self.dismiss()
            agreeCallback()
        }
        privateView.disAgreeCallBack = {
            disAgreeCallback()
        }
        privateView.userProtocol = {
            userProCallback()
        }
        privateView.privateProtocol = {
            privateProCallback()
        }
    }
    
    func animationWithView(view: UIView,duration: TimeInterval) {
        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        var values = [NSValue]()
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        animation.timingFunction = CAMediaTimingFunction.init(name: "easeInEaseOut")
        view.layer.add(animation, forKey: nil)
    }
    
    @objc func maskViewTapAction(tap: UITapGestureRecognizer) {
        self.dismiss()
    }
    
    func dismiss() {
        self.privateAlertView.removeFromSuperview()
        self.maskrView.removeFromSuperview()
    }

}

class PrivateAlertView: UIView {

    var userProtocol: (()->())?
    var privateProtocol: (()->())?
    
    var agreeCallBack: (()->())?
    var disAgreeCallBack: (()->())?

    let margin: CGFloat = 10
    var contents = [String]()
    
    var titleLabel = UILabel()
    var disAgreeBtn = UIButton()
    var agreeBtn = UIButton()

    lazy var contentTableView: UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        let frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        tableview.tableHeaderView = UIView(frame: frame)
        tableview.backgroundColor = .white
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.showsVerticalScrollIndicator = false
        tableview.estimatedRowHeight = 60
        tableview.register(AgreeContentCell.self, forCellReuseIdentifier: "AgreeContentCell")
        return tableview
    }()
    
    let agreementText = "点击同意即表示您已阅读并同意《用户协议》与《隐私政策》"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, contents: [String]) {
        self.init(frame: frame)
        self.contents = contents
        self.setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        self.addSubview(contentTableView)
        self.addSubview(disAgreeBtn)
        self.addSubview(agreeBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = "温馨提示"
        titleLabel.textColor = .black
        
        contentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-60)
        }
        
        disAgreeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentTableView.snp.bottom).offset(margin)
            make.left.equalTo(margin)
            make.bottom.equalTo(-margin)
            make.width.equalTo(100)
        }
        disAgreeBtn.backgroundColor = UIColor.gray
        disAgreeBtn.setTitle("不同意", for: .normal)
        disAgreeBtn.addTarget(self, action: #selector(disAgreeBtnAction(btn:)), for: .touchUpInside)
        
        agreeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentTableView.snp.bottom).offset(margin)
            make.right.bottom.equalTo(-margin)
            make.width.equalTo(100)
        }
        agreeBtn.backgroundColor = UIColor.blue
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.addTarget(self, action: #selector(agreeBtnAction(btn:)), for: .touchUpInside)
    }
    
    @objc func disAgreeBtnAction(btn: UIButton) {
        if self.disAgreeCallBack != nil {
            self.disAgreeCallBack!()
        }
    }
    
    @objc func agreeBtnAction(btn: UIButton) {
        if self.agreeCallBack != nil {
            self.agreeCallBack!()
        }
    }
    
}

extension PrivateAlertView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AgreeContentCell = tableView.dequeueReusableCell(withIdentifier: "AgreeContentCell") as! AgreeContentCell
        cell.contentLabel.text = self.contents[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView: AgreeFootView = AgreeFootView(frame: CGRect(x: 0, y: 0, width: self.width, height: 60))
        footView.userProtocol = {
            if self.userProtocol != nil {
                self.userProtocol!()
            }
        }
        
        footView.privateProtocol = {
            if self.privateProtocol != nil {
                self.privateProtocol!()
            }
        }
        
        return footView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}

class AgreeContentCell: UITableViewCell {
    
    let margin: CGFloat = 10
    var contentLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.contentView.addSubview(contentLabel)
        contentLabel.textColor = UIColor.gray
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(margin)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-margin)
        }
    }
    
}

class AgreeFootView: UIView {
    
    var userProtocol: (()->())?
    var privateProtocol: (()->())?

    let margin: CGFloat = 10
    var agreementLabel = YYLabel()
    let agreementText = "点击同意即表示您已阅读并同意《用户协议》与《隐私政策》"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        let text = NSMutableAttributedString.init(string: agreementText)
        text.yy_lineSpacing = 5
        text.yy_font = UIFont.systemFont(ofSize: 15)
        text.yy_color = UIColor.black

        text.yy_setTextHighlight(NSMakeRange(14, 6), color: UIColor.blue, backgroundColor: UIColor.clear) { (containerView, text, range, rect) in
            if self.userProtocol != nil{
                self.userProtocol!()
            }
        }
        
        text.yy_setTextHighlight(NSMakeRange(agreementText.count - 6, 6), color: UIColor.blue, backgroundColor: UIColor.clear) { (containerView, text, range, rect) in
            if self.privateProtocol != nil {
                self.privateProtocol!()
            }
        }
        
        agreementLabel.numberOfLines = 0
        agreementLabel.preferredMaxLayoutWidth = self.width - 2 * margin
        agreementLabel.attributedText = text
        self.addSubview(agreementLabel)
        agreementLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}


