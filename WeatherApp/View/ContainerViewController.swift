//
//  ContainerViewController.swift
//  WeatherApp
//
//  Created by kluv on 13/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, ViewControllerDelegate {
    
    enum SlideOutState {
      case menuCollapsed
      case menuExpanded
    }
    
    var currentState: SlideOutState = .menuCollapsed
    
    var mainViewController: UIViewController!
    var menuViewController: UIViewController!
    var mainNavController: UINavigationController!
    var isMove = false
    var screenHalfQuarterWidth: CGFloat!
    var offsetToMenuExpand: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        screenHalfQuarterWidth = view.bounds.size.width/8
        offsetToMenuExpand = screenHalfQuarterWidth*2
        
        configureMainViewController()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        mainNavController.view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    func configureMainViewController() {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        mainNavController = navController
        let mainVC: ViewController = navController.viewControllers[0] as! ViewController
        mainVC.delegate = self
        mainViewController = mainVC
        self.add(navController)
    }
    
    func configureMenuViewController() {
        menuViewController = MenuViewController()
        addChild(menuViewController)
        view.insertSubview(menuViewController.view, at: 0)
        menuViewController.didMove(toParent: self)
    }
        
    func animateLeftmenu(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .menuExpanded
            animateCenterPanel(targetPosition: screenHalfQuarterWidth*4) { _ in
                self.isMove = !self.isMove
            }
        } else {
            animateCenterPanel(targetPosition: 0) { _ in
                self.currentState = .menuCollapsed
                self.menuViewController.remove()
            }
        }
        
    }
    
    func animateCenterPanel(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        let dampingRatio: CGFloat = targetPosition == 0 ? 1 : 0.6
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.mainNavController.view.frame.origin.x = targetPosition
        }, completion: completion)
        
    }
    
    
    //MARK: ViewControllerDelegate
    func toggleMenu() {
        
        let notAlreadyExpanded = currentState != .menuExpanded
        
        if notAlreadyExpanded {
            configureMenuViewController()
        }
        
        animateLeftmenu(shouldExpand: notAlreadyExpanded)
        
    }

    // MARK: Gesture recognizer
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = recognizer.velocity(in: view).x > 0
    
        switch recognizer.state {
        case .began:
            if gestureIsDraggingFromLeftToRight {
                configureMenuViewController()
            }
        
        case .changed:
            if let rView = recognizer.view {
                                
                let centerX = view.bounds.width/2
                var draggingDisctance = recognizer.translation(in: view).x
                let currentCenterX = rView.center.x
                
                //Only left menu
                if (currentCenterX + draggingDisctance) < centerX {
                    draggingDisctance -= ((currentCenterX + draggingDisctance) - centerX)
                }
                
                if rView.frame.origin.x > offsetToMenuExpand {
                    draggingDisctance *= 1.5
                }
                
                rView.center.x = rView.center.x + draggingDisctance
                recognizer.setTranslation(CGPoint.zero, in: view)

            }
            
        case .ended:
            if let _ = menuViewController, let rView = recognizer.view {
                let hasMoveGreaterThanHalfway = rView.frame.origin.x > offsetToMenuExpand
                
                animateLeftmenu(shouldExpand: hasMoveGreaterThanHalfway)
            }
            
        default:
            break
            
        }
        
    }
    
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
