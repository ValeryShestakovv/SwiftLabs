import UIKit

final class AnimationController: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType
    private let cellFrame: CGRect
    enum AnimationType {
        case present
        case dismiss
    }
    init(animationDuration: Double, animationType: AnimationType, cellFrame: CGRect) {
        self.animationDuration = animationDuration
        self.animationType = animationType
        self.cellFrame = cellFrame
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewConroller = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            let xScaleFactor = cellFrame.width / toViewController.view.frame.width
            let yScaleFactor = cellFrame.height / toViewController.view.frame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            let center = CGPoint(x: toViewController.view.frame.midX, y: toViewController.view.frame.midY)
            presentAnimation(with: transitionContext,
                             viewToAnimate: toViewController.view,
                             scale: scaleTransform,
                             center: center)
        case .dismiss:
            transitionContext.containerView.addSubview(fromViewConroller.view)
            let xScaleFactor = cellFrame.width / fromViewConroller.view.frame.width
            let yScaleFactor = cellFrame.height / fromViewConroller.view.frame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            let center = CGPoint(x: cellFrame.midX, y: cellFrame.midY)
            dismissAnimation(with: transitionContext,
                             viewToAnimate: fromViewConroller.view,
                             scale: scaleTransform,
                             center: center)
        }
    }
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning,
                          viewToAnimate: UIView, scale: CGAffineTransform, center: CGPoint) {
        viewToAnimate.transform = scale
        viewToAnimate.center = CGPoint(
          x: cellFrame.midX,
          y: cellFrame.midY)
        viewToAnimate.layer.cornerRadius = 20
        viewToAnimate.clipsToBounds = true
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut) {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            viewToAnimate.center = center
            viewToAnimate.layer.cornerRadius = 0

        } completion: { _ in
            transitionContext.completeTransition(true)
        }

    }
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning,
                          viewToAnimate: UIView, scale: CGAffineTransform, center: CGPoint) {
        viewToAnimate.layer.cornerRadius = 0
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseIn) {
            viewToAnimate.transform = scale
            viewToAnimate.center = center
            viewToAnimate.layer.cornerRadius = 20
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
