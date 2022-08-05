//
//  ToastView.swift
//  TipsView
//
//  Created by lax on 2022/8/4.
//

import UIKit
import SnapKit

extension ToastView {
        
    public enum Style {
        case normal
        case success
        case error
        case warning
    }
    
    public enum Position {
        case top
        case center
        case bottom
    }

}
    
public class ToastView: UIView {
    
    private var timer: Timer?
    
    private(set) var positon: Position = ToastView.defaultPosition
    
    private(set) var style: Style = .normal
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private(set) lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        backgroundColor = UIColor(white: 0, alpha: 0.8)
        layer.cornerRadius = 10
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension ToastView {
    
    public func show(in view: UIView, position: Position = .center, style: Style = .normal, image: UIImage? = nil, message: String?, delay: Double = 3, animated: Bool = true) {
        if (message?.count == 0) { return }
        
        self.positon = position
        self.style = style
        tipsLabel.text = message
        
        view.addSubview(self)
        snp.makeConstraints { (make) in
            if (positon == .center) {
                make.centerY.equalToSuperview()
            } else if (positon == .top) {
                make.top.equalToSuperview().offset(100)
            } else if (positon == .bottom) {
                make.bottom.equalToSuperview().offset(-100)
            }
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-100)
            make.height.lessThanOrEqualToSuperview().offset(-200)
            if style != .normal {
                make.width.greaterThanOrEqualTo(100)
                make.height.greaterThanOrEqualTo(100)
            }
        }

        switch style {
        case .normal:
            addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-10)
            }
        case .success, .error, .warning:
            addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(40)
            }
            addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.bottom.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            if message == nil || message == "" {
                imageView.snp.updateConstraints { (make) in
                    make.height.equalTo(100)
                }
            }
        }
        
        switch style {
        case .normal:
            layoutIfNeeded()
            layer.cornerRadius = frame.size.height < 40 ? frame.size.height / 2 : 8
            imageView.image = nil
        default:
            imageView.image = image
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.hide()
        }
        
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.alpha = 1
        }
    }
    
    public func hide(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            self.alpha = 0
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
        timer?.invalidate()
        timer = nil
    }
    
}

extension ToastView {
    
    // 默认显示位置
    public static var defaultPosition: Position = .center
    
    // 成功提示的图片
    public static var successImage: UIImage?
    // 失败提示的图片
    public static var errorImage: UIImage?
    // 警告提示的图片
    public static var warningImage: UIImage?
    
}

extension ToastView {
    
    /// 消息提示
    /// - Parameter message: 消息内容
    public static func show(_ message: String?) {
        if message == nil || message == "" { return }
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        ToastView().show(in: window, position: ToastView.defaultPosition, style: .normal, image: nil, message: message)
    }
    
    /// 成功提示
    /// - Parameter message: 消息内容
    public static func showSuccess(_ message: String? = "", image: UIImage? = ToastView.successImage) {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        ToastView().show(in: window, position: ToastView.defaultPosition, style: .success, image: image, message: message)
    }
    
    /// 错误提示
    /// - Parameter message: 消息内容
    public static func showError(_ message: String? = "", image: UIImage? = ToastView.errorImage) {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        ToastView().show(in: window, position: ToastView.defaultPosition, style: .error, image: image, message: message)
    }
    
    /// 警告提示
    /// - Parameter message: 消息内容
    public static func showWarning(_ message: String? = "", image: UIImage? = ToastView.warningImage) {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        ToastView().show(in: window, position: ToastView.defaultPosition, style: .warning, image: image, message: message)
    }
    
}

/// 消息提示框
/// - Parameter message: 消息内容
public func Toast(_ message: String?) {
    ToastView.show(message)
}
