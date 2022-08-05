//
//  HUDView.swift
//  TipsView
//
//  Created by lax on 2022/8/4.
//

import UIKit
import SnapKit

extension HUDView {
    
    public enum Style {
        case `default`
        case light
    }
    
}

public class HUDView: UIView {
    
    private(set) var style: Style = .default {
        didSet {
            switch style {
            case .light:
                setStyleLight()
            default:
                setStyleDefault()
            }
        }
    }
    
    private(set) var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.02).cgColor
        view.layer.shadowOffset = CGSize()
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0
        return view
    }()
    
    private(set) lazy var indicatorView: UIActivityIndicatorView = {
        let active = UIActivityIndicatorView(style: .whiteLarge)
        active.hidesWhenStopped = true
        active.startAnimating()
        return active
    }()
    
    private(set) lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        tag = HUDView.hudViewTag
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension HUDView {
    
    public func show(in view: UIView?, style: Style = .default, top offset: CGFloat = 0, message: String?) {
        guard let _ = view else { return }
        view!.viewWithTag(HUDView.hudViewTag)?.removeFromSuperview()
        view!.addSubview(self)
        
        var rect = view!.frame
        rect.origin.y = offset
        rect.size.height -= offset
        frame = rect
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-offset / 2)
        }
        
        contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(indicatorView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        tipsLabel.text = message
        self.style = style
        
        if (HUDView.loadSlowTimeInterval > 0) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + HUDView.loadSlowTimeInterval) {
                self.loadSlow()
            }
        }
    }
    
    public func hide() {
        removeFromSuperview()
    }
    
    private func loadSlow() {
        indicatorView.color = HUDView.loadSlowColor
        tipsLabel.textColor = HUDView.loadSlowColor
        tipsLabel.text = HUDView.loadSlowMessage
    }
    
    private func setStyleDefault() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        indicatorView.style = .whiteLarge
        indicatorView.color = .white
        tipsLabel.textColor = .white
    }
    
    private func setStyleLight() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.6)
        indicatorView.style = .whiteLarge
        indicatorView.color = .darkGray
        tipsLabel.textColor = .lightGray
    }

}

extension HUDView {
    
    // tag
    public static var hudViewTag = 910
    
    // 加载中的提示
    public static var defaultMessage = "正在加载"
    
    // 加载缓慢提示
    public static var loadSlowMessage = "加载缓慢"
    
    // 设置加载缓慢时间 默认5s 设置0则不出现加载缓慢
    public static var loadSlowTimeInterval = 5.0
    
    // 加载缓慢颜色
    public static var loadSlowColor = UIColor.orange
    
    public static let shared = HUDView()
    
    /// 开始动画
    /// - Parameter view: 目标视图
    /// - Parameter message: 提示文字
    public static func show(in view: UIView?, message: String? = HUDView.defaultMessage) {
        HUDView.shared.show(in: view, message: message)
    }
    
    /// 结束动画
    public static func hide() {
        HUDView.shared.hide()
    }
    
}

extension UIView {
    
    /// 开始动画
    /// - Parameter message: 提示文字
    public func showHUD(_ message: String? = HUDView.defaultMessage) {
        if let hudView = viewWithTag(HUDView.hudViewTag) as? HUDView {
            bringSubviewToFront(hudView)
        } else {
            let hudView = HUDView()
            hudView.show(in: self, message: message)
        }
    }
    
    /// 结束动画
    public func hideHUD() {
        viewWithTag(HUDView.hudViewTag)?.removeFromSuperview()
    }
    
}
