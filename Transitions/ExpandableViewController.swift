//
//  ViewController.swift
//  Transitions
//
//  Created by Rajiv Jhoomuck on 11/04/2021.
//

import UIKit

class ExpandableViewController: UIViewController {
  private(set) weak var containerView: UIView?
  private(set) weak var containerViewController: UIViewController?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    transitioningDelegate = self
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    transitioningDelegate = self
  }

  public override var modalPresentationStyle: UIModalPresentationStyle {
    willSet { assert(newValue == .fullScreen, "Modal presentation style other than `.fullScreen` is not supported.") }
    didSet { super.modalPresentationStyle = .fullScreen }
  }

  public override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)

    if let parent = parent {
      containerView = view.superview
      containerViewController = parent
    }
  }
}

extension ExpandableViewController {
  @IBAction func presentationToggleButtonTapped(_ button: UIButton) {
    guard isBeingPresented == false, isBeingDismissed == false else {
      return
    }
    if presentingViewController != nil {
      dismiss(animated: true) { [weak self] in
        guard let self = self else { return }

        self.containerViewController?.addChild(self)
        self.beginAppearanceTransition(true, animated: false)
        self.containerView?.embed(self.view, atIndex: nil, insets: .zero)
        self.endAppearanceTransition()
        self.didMove(toParent: self.containerViewController)
        button.setTitle("Expand", for: .normal)
      }
    } else if let container = containerViewController {
      willMove(toParent: nil)
      self.beginAppearanceTransition(false, animated: false)
      view.removeFromSuperview()
      self.endAppearanceTransition()
      removeFromParent()

      container.present(self, animated: true) {
        button.setTitle("Dismiss", for: .normal)
      }
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
