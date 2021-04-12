//
//  Animator.swift
//  Transitions
//
//  Created by Rajiv Jhoomuck on 11/04/2021.
//

import UIKit

class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  private let transitionDuration = TimeInterval(0.33)
  private let isPresenting: Bool

  init(isPresenting: Bool = true) {
    self.isPresenting = isPresenting
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { transitionDuration }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let transitionView = transitionContext.containerView

    guard
      let expandableViewController = transitionContext.viewController(forKey: isPresenting ? .to : .from) as? ExpandableViewController,
      let expandableViewControllerRootView = expandableViewController.view else {
      return
    }
    transitionView.addSubview(expandableViewControllerRootView)

    expandableViewControllerRootView.frame = isPresenting
      ? expandableViewController.containerView.map { $0.convert($0.bounds, to: transitionView)} ?? .zero
      : transitionContext.initialFrame(for: expandableViewController)

    transitionView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3) // debugging

    let finalFrame = isPresenting
        ? transitionContext.finalFrame(for: expandableViewController) // transitionContainerView.frame
        : expandableViewController.containerView.map { $0.convert($0.bounds, to: transitionView)} ?? .zero

    print(finalFrame)

//    print("""
//\(isPresenting ? "[Presentation]" : "[Dismissal]")
//  transitionView  : \(transitionContainerView.frame)
//  initialFrame    : \(transitionContext.initialFrame(for: expandableViewController))
//  finalFrame      : \(transitionContext.finalFrame(for: expandableViewController))
//""")``

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: transitionDuration, delay: 0, options: .curveLinear) {
        expandableViewControllerRootView.frame = finalFrame
        transitionView.layoutIfNeeded()
    }
    completion: { _ in

//      print("\tAfter completion:", expandableViewControllerRootView.frame, "\n------------------\n")
      if transitionContext.transitionWasCancelled {
        expandableViewController.view.removeFromSuperview()
      }
      else {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    }
  }
}
