//
//  BaseAlertController.swift
//  MCBaseAlertView
//
//  Created by zc_mc on 2021/9/16.
//

import UIKit

let alertControllerAnimationTime = 0.35

class BaseAlertController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = UIModalPresentationStyle.custom
        transitioningDelegate = self
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    private var aniView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @objc private func maskViewTapClicked() {
        dismissView(aniView: aniView ?? view)
    }
    
}

extension BaseAlertController {
    
    func showView(aniView: UIView, isGesture: Bool = false) {
        self.aniView = aniView
        
        if isGesture {
            let tap = UITapGestureRecognizer(target: self, action: #selector(maskViewTapClicked))
            self.view.addGestureRecognizer(tap)
        }
        
        aniView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: alertControllerAnimationTime, animations: {
            aniView.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
    }
    
    func dismissView(aniView: UIView, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: alertControllerAnimationTime, animations: {
            aniView.transform = CGAffineTransform(translationX: 0, y: aniView.frame.height)
        }, completion: completion)
        
        self.dismiss(animated: true, completion: nil)
    }
   
}


extension BaseAlertController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        BasePresntAnimate()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        BaseDismissAnimate()
    }
    
}

class BasePresntAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        alertControllerAnimationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? BaseAlertController,
              let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)  else {
            return
        }
        
        let containerV = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        containerV.addSubview(toVC.view)
        toVC.view.frame = containerV.bounds
        toVC.view.alpha = 0
        // toVC 的 承载内容的动画
//        toVC.showView()
        
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

class BaseDismissAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        alertControllerAnimationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? BaseAlertController else {
                return
        }
        
        let duration = self.transitionDuration(using: transitionContext)
//        fromVC.dismissView { (_) in
//            
//        }
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.alpha = 0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}
