//
//  ViewController.swift
//  TipsViewDemo
//
//  Created by lax on 2022/8/5.
//

import UIKit
import TipsView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        testLoadView()
        testToastView()
        testHUDView()
        
    }
    
    func testHUDView() {
        
        HUDView.show(in: self.view)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
            HUDView.hide()
        }

//        view.showHUD()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
//            self.view.hideHUD()
//        }
        
    }
    
    func testToastView() {
        
        ToastView.defaultPosition = .bottom
        
//        if #available(iOS 13.0, *) {
//            ToastView.showError("adfadf", image: UIImage(systemName: "square.and.arrow.up"))
//        }
        Toast("hahahaha")
        return;
        
    }
    
    func testLoadView() {
        
        LoadView.defaultErrorMessage = "hahaha"
        
        view.loading("loading")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.view.endLoading()
            if #available(iOS 13.0, *) {
//                self.view.endLoadingWithError(image: UIImage(systemName: "square.and.arrow.up")) {
//                    self.startRequest()
//                }
                self.view.endLoadingWithNoData(image: UIImage(systemName: "square.and.arrow.up"))
            }
        }
    }
    
}

