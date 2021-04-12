//
//  ViewController.swift
//  Transitions
//
//  Created by Rajiv Jhoomuck on 11/04/2021.
//

import UIKit

class ExpandableViewController: UIViewController {
  private var hasBeenPresented = true
  private(set) weak var containerView: UIView?
  private(set) weak var containerViewController: UIViewController?

  public override var modalPresentationStyle: UIModalPresentationStyle {
    willSet { assert(newValue == .fullScreen, "Modal presentation style other than `.fullScreen` is not supported.") }
    didSet { super.modalPresentationStyle = .fullScreen }
  }

  public override func didMove(toParent parent: UIViewController?) {
      super.didMove(toParent: parent)

      if parent != nil {
        containerView = view.superview
        containerViewController = parent
      }

      hasBeenPresented = parent == nil
    }
}

extension ExpandableViewController {
  @IBAction func presentationToggleButtonTapped(_ button: UIButton) {
    if hasBeenPresented {
      dismiss(animated: true) { [weak self] in
        guard let self = self else { return }

        self.willMove(toParent: self.containerViewController)
        self.containerView?.embed(self.view, atIndex: nil, insets: .zero)
        self.containerViewController?.addChild(self)
        self.didMove(toParent: self.containerViewController)
        button.setTitle("Expand", for: .normal)
      }
    } else if let container = containerViewController {
      willMove(toParent: nil)
        // view.removeFromSuperview()
        // For some reason, removing the view from the superview cause a warning:
        // Unbalanced calls to begin/end appearance transitions for <ExpandableViewController: 0x7fc7a2072400>.
      removeFromParent()

      transitioningDelegate = self
      container.present(self, animated: true) { button.setTitle("Dismiss", for: .normal) }
    }
  }
}

extension ExpandableViewController: UIViewControllerTransitioningDelegate {
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    PresentationAnimator(isPresenting: true)
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    PresentationAnimator(isPresenting: false)
  }
}
