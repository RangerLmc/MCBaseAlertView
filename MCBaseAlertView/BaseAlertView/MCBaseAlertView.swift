
//
//  BaseAlertView.swift
//  MCBaseAlertView
//
//  Created by zc_mc on 2021/9/15.
//

import UIKit

/// 动画类型
enum AlertAnimation {
    
    // 从上往下
    case top
    case bottom
    case left
    case right
    // 渐出
    case fade
    // 回弹
    case pop
    case none
}

class AlertController: UIViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return nil
    }
}

class MCBaseAlertView: NibView {
    
    // MARK: Public
    /// 点击蒙层是否消失
    var isGesture = false
    /// 背景蒙层颜色透明度
    var bgColor: UIColor = UIColor("#000000")!.withAlphaComponent(0.6)
    /// 点击蒙层的回调
    var maskTapAction: (() -> ())?
    
    // MARK: Private
    private let animationTime: TimeInterval = 0.3
    
    private var hiddenColor = UIColor("#000000")!.withAlphaComponent(0)
    
    private lazy var newWindow: UIWindow? = {
        let view = UIWindow(frame: UIScreen.main.bounds)
        view.windowLevel = .alert
        view.backgroundColor = UIColor.clear
        
        if #available(iOS 13.0, *) {
            if UIApplication.shared.windows.count > 0 {
                UIApplication.shared.windows.forEach { window in
                    if window.windowLevel == .normal{
                        view.windowScene = window.windowScene
                    }
                }
            }
        }
        
        return view
    }()
    
    private var tempWindow: UIWindow? = UIApplication.kw_getKeyWindow()
    private var showAniType: AlertAnimation = .fade
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: Public
    /// 弹出
    /// - Parameters:
    ///   - animation: 动画类型
    ///   - isGesture: 蒙层点击是否相应
    func show(animation: AlertAnimation = .fade) {
        
        self.showAniType = animation

       let controller = AlertController()
        newWindow?.rootViewController = controller
        newWindow?.rootViewController?.view = self
        newWindow?.makeKeyAndVisible()
        
        setupGesture()
        
        switch animation {
        case .top, .left, .bottom, .right:
            self.center = setViewCenter(animation: animation)
            UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut, animations: {
                self.center = self.setViewCenter(animation: .none)
                self.newWindow?.backgroundColor = self.bgColor
                
            }, completion: nil)
        
        case .fade:
            self.alpha = 0
            self.center = setViewCenter(animation: animation)
            UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 1
                self.newWindow?.backgroundColor = self.bgColor
                
            }, completion: nil)
            
        case .pop:
            self.alpha = 0
            self.center = setViewCenter(animation: animation)
            UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 1
                self.newWindow?.backgroundColor = self.bgColor
                
            }, completion: nil)
            
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimation.isRemovedOnCompletion = true
            scaleAnimation.duration = animationTime
            scaleAnimation.timingFunctions = [CAMediaTimingFunction(name: .linear)]
            scaleAnimation.values = [0.01, 1.1, 0.9, 1.0]
            self.layer.add(scaleAnimation, forKey: nil)
            
        case .none:
            self.newWindow?.backgroundColor = self.bgColor
        
        }
        
    }
    
    func dismiss(animation: AlertAnimation = .none) {
        
        self.tempWindow?.makeKeyAndVisible()
        
        switch animation {
        case .top, .left, .bottom, .right:
            
            UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut) {
                self.center = self.setViewCenter(animation: animation)
                self.backgroundColor = self.hiddenColor
            } completion: { _ in
                self.removeFromSuperview()
                self.newWindow?.removeFromSuperview()
                self.newWindow = nil
            }


        case .fade, .pop:
            UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut) {
                self.alpha = 0
                self.newWindow?.backgroundColor = self.hiddenColor
            } completion: { _ in
                self.removeFromSuperview()
                self.newWindow?.removeFromSuperview()
                self.newWindow = nil
            }
            
        case .none:
            self.alpha = 0
            self.newWindow?.backgroundColor = self.hiddenColor
            self.removeFromSuperview()
            self.newWindow?.removeFromSuperview()
            self.newWindow = nil
        }
        
    }
    
    private func setupGesture() {
        if !isGesture { return }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgViewTapAction))
        newWindow?.rootViewController?.view.addGestureRecognizer(tap)
    }
    
    @objc private func bgViewTapAction() {
        dismiss(animation: showAniType)
        maskTapAction?()
    }
    
    
    /// 设置中心值
    private func setViewCenter(animation: AlertAnimation) -> CGPoint {
        
        let bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        var center = CGPoint.zero
        
        switch animation {
        case .top:
            center.x = bounds.width/2
            center.y = 0 - bounds.height/2
            
        case .left:
            center.x = -bounds.width/2
            center.y = bounds.height/2
            
        case .bottom:
            center.x = bounds.width/2
            center.y = self.bounds.height + bounds.height/2
            
        case .right:
            center.x = self.bounds.width + bounds.width/2
            center.y = bounds.height/2
            
        case .fade, .pop, .none:
            center.x = bounds.width/2
            center.y = bounds.height/2
        
        }
        return center
    }

}

class NibView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        loadNib()
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadNib()
        
        setupSubviews()
    }
    
    /// 配置子视图
    open func setupSubviews() {
        
    }
    deinit {
        print(self, "deinit")
    }
}

private extension NibView {
    
    func loadNib() {
        
        backgroundColor = UIColor.clear
        
        view = loadXib()
        
        view.frame = bounds
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView": view as Any]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",  options: [], metrics: nil, views: ["childView": view as Any]))

    }
}

extension UIView {
    
    func loadXib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}


extension UIApplication {
    class func kw_getKeyWindow() -> UIWindow? {
        if UIApplication.shared.keyWindow != nil {
            return UIApplication.shared.keyWindow
        }
        if let window = UIApplication.shared.windows.last {
            return window
        }
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes.filter {
                $0.activationState == .foregroundActive
            }
            .map { $0 as? UIWindowScene }.compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
            return keyWindow
        }
        return nil
    }
}
