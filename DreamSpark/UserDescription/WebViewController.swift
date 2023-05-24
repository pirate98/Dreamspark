//
//  WebViewController.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 02/11/21.
//

import UIKit
import WebKit
import ObjectMapper

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    var webURLString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEstimatedProgressObserverForWebView()
        progressView.progressTintColor = BLUE
        loadWebView(urlString: webURLString)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
}

extension WebViewController {
    private func localizedUpdate(){
    }
    
    private func setupEstimatedProgressObserverForWebView() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    private func loadWebView(urlString: String?){
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        
        guard let urlString = urlString, let url = URL(string: urlString) else{
            showMessageAlert(message: "URL is invalid", onRetry: {
                self.setupEstimatedProgressObserverForWebView()
                self.loadWebView(urlString: urlString)
            }, onCancel: {
                self.dismiss(animated: true, completion: nil)
            })
            return
        }
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        if progressView.isHidden {
            progressView.isHidden = false
            progressView.alpha = 0.0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.progressView.alpha = 1.0
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.progressView.alpha = 0.0
        }, completion: { isFinished in
            self.progressView.isHidden = isFinished
            self.progressView.progress = 0.0
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showMessageAlert(message: error.localizedDescription, onRetry: {
            self.setupEstimatedProgressObserverForWebView()
            self.loadWebView(urlString: webView.url?.absoluteString)
        }, onCancel: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        showMessageAlert(message: error.localizedDescription, onRetry: {
            self.setupEstimatedProgressObserverForWebView()
            self.loadWebView(urlString: webView.url?.absoluteString)
        }, onCancel: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
