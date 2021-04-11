//
//  Animator.swift
//  Transitions
//
//  Created by Rajiv Jhoomuck on 11/04/2021.
//

import UIKit

class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  private let transitionDuration = TimeInterval(3.33)
  private let isPresenting: Bool

  init(isPresenting: Bool = true) {
    self.isPresenting = isPresenting
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { transitionDuration }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let transitionContainerView = transitionContext.containerView

    guard
      let expandableViewController = transitionContext.viewController(forKey: isPresenting ? .to : .from) as? ExpandableViewController,
      let expandableViewControllerRootView = expandableViewController.view else {
      return
    }

//    if isPresenting {
//      transitionContainerView.embed(expandableViewControllerRootView, atIndex: nil, insets: .zero)
//    } else {
//      transitionContainerView.addSubview(expandableViewControllerRootView)
//    }

    transitionContainerView.embed(expandableViewControllerRootView, atIndex: nil, insets: .zero)

//    transitionContainerView.addSubview(expandableViewControllerRootView)

    if isPresenting {
      expandableViewControllerRootView.frame = expandableViewController.containerView?.frame
        ?? CGRect(origin: .zero, size: CGSize(width: 200, height: 175))//.zero
    }

    transitionContainerView.backgroundColor = .systemTeal // debugging

    let finalFrame = isPresenting
      ? transitionContainerView.frame
      : (expandableViewController.containerView?.frame ?? .zero)

    print("""
isPresenting  : \(isPresenting ? "Presentation" : "Dismissal")
transitionView: \(transitionContainerView.frame)
initialFrame  : \(transitionContext.initialFrame(for: expandableViewController))
finalFrame    : \(transitionContext.finalFrame(for: expandableViewController))
""")


    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: transitionDuration, delay: 0, options: .curveLinear) {
      expandableViewController.view.frame = finalFrame
      expandableViewController.view.layoutIfNeeded()
    }
    completion: { _ in

      print(expandableViewControllerRootView.frame, "\n------------------\n")
      if transitionContext.transitionWasCancelled {
        expandableViewController.view.removeFromSuperview()
      }
      else {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    }
  }
}
