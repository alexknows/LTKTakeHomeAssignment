//
//  ActivityIndicator.swift
//  LTK
//
//  Created by Alex Cruz on 1/27/22.
//

import UIKit

extension ViewLoadingManagerView where Self: UIView {
    func showLoading() {
        layoutIfNeeded()
        let activityIndicator = UIActivityIndicatorView()
        createLoadingView(with: activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        if let loadingView = self.viewWithTag(100) {
            loadingView.removeFromSuperview()
        }
    }
    
    private func createLoadingView(with activityIndicator: UIActivityIndicatorView) {
        layoutIfNeeded()
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let loadingView = UIVisualEffectView(effect: blurEffect)
        loadingView.frame = bounds
        
        loadingView.tag = 100
        loadingView.layer.cornerRadius = layer.cornerRadius
        loadingView.clipsToBounds = true
        
        customizeActivityIndicator(with: activityIndicator,
                                   on: loadingView)
        
        self.addSubview(loadingView)
    }
    
    fileprivate func customizeActivityIndicator(with activityIndicator: UIActivityIndicatorView,
                                                on loadingView: UIVisualEffectView) {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.contentView.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: loadingView.contentView.centerXAnchor, constant: 0.0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loadingView.contentView.centerYAnchor, constant: 0.0).isActive = true
    }
    
    var frame: CGRect {
        layoutIfNeeded()
        return bounds
    }
    
    func use(_ view: UIView) {
        addSubview(view)
    }
    
    func dontUse(viewWithTag tag: Int) {
        guard let view = viewWithTag(tag) else { return }
        view.removeFromSuperview()
    }
    
}

extension ViewLoadingManagerView where Self: UITableView {
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView()
        createLoadingView(with: activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        guard backgroundView?.tag == 100 else { return }
        backgroundView = nil
    }
    
    private func createLoadingView(with activityIndicator: UIActivityIndicatorView) {
        layoutIfNeeded()
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        
        visualEffectView.tag = 100
        visualEffectView.layer.cornerRadius = layer.cornerRadius
        
        customizeActivityIndicator(with: activityIndicator,
                                   on: visualEffectView)
        
        backgroundView = visualEffectView
    }
    
    func use(_ view: UIView) {
        backgroundView = view
    }
    
    func dontUse(viewWithTag tag: Int) {
        guard backgroundView?.tag == tag else { return }
        backgroundView = nil
    }
    
}

extension ViewLoadingManagerView where Self: UICollectionView {
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView()
        createLoadingView(with: activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        backgroundView = nil
    }
    
    private func createLoadingView(with activityIndicator: UIActivityIndicatorView) {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        
        visualEffectView.tag = 100
        visualEffectView.layer.cornerRadius = layer.cornerRadius
        
        customizeActivityIndicator(with: activityIndicator,
                                   on: visualEffectView)
        
        backgroundView = visualEffectView
    }
    
    func use(_ view: UIView) {
        backgroundView = view
    }
    
    func dontUse(viewWithTag tag: Int) {
        guard backgroundView?.tag == tag else { return }
        backgroundView = nil
    }
    
}

extension UIView: ViewLoadingManagerView {}

