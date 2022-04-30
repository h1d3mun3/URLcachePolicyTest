//
//  ViewController.swift
//  URLcachePolicyTest
//
//  Created by hidemune on 4/29/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var cookieField: UITextView!
    @IBOutlet weak var urlField: UITextField!

    var urlSession: URLSession!
    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration)

        updateCookieField()
    }
}

extension ViewController {
    func updateResponsefield(data: Data?, response: URLResponse?, error: Error?) {
        DispatchQueue.main.async {
            var result = ""

            result.append(String(data: data ?? Data(), encoding: .utf8) ?? "")
            result.append(response?.description ?? "")
            result.append(error?.localizedDescription ?? "")

            self.resultTextView.text = result
        }
    }

    func updateCookieField() {
        DispatchQueue.main.async {
            var cookies = ""
            let currentCookies = HTTPCookieStorage.shared.cookies ?? []
            currentCookies.forEach({ cookies.append($0.description) })

            self.cookieField.text = cookies
        }
    }
}

extension ViewController {
    @IBAction func tapped(_ sender: Any) {
        resultTextView.resignFirstResponder()
        cookieField.resignFirstResponder()
        urlField.resignFirstResponder()
    }
}

extension ViewController {
    func request() {
        resultTextView.text = ""

        guard let url = URL(string: urlField.text ?? "") else { return }

        var urlRequest = URLRequest.init(url: url)
        urlRequest.cachePolicy = cachePolicy
        urlRequest.addValue(cachePolicy.extractDebugString(), forHTTPHeaderField: "URLRequest.CachePolicy")

        let task =  urlSession.dataTask(
            with: urlRequest,
            completionHandler: { [weak self] data, response, error in
                guard let self = self else { return }

                self.updateResponsefield(data: data, response: response, error: error)
                self.updateCookieField()
            })

        task.resume()
    }
}

extension ViewController {
    @IBAction func useProtocolCachePolicyTapped(_ sender: Any) {
        cachePolicy = .useProtocolCachePolicy

        request()
    }

    @IBAction func reloadIgnoringLocalCacheDataTapped(_ sender: Any) {
        cachePolicy = .reloadIgnoringLocalCacheData

        request()
    }

    @IBAction func returnCacheDataElseLoadTapped(_ sender: Any) {
        cachePolicy = .returnCacheDataElseLoad

        request()
    }

    @IBAction func returnCacheDataDontLoadTapped(_ sender: Any) {
        cachePolicy = .returnCacheDataDontLoad

        request()
    }

    @IBAction func reloadIgnoringLocalAndRemoteCacheDataTapped(_ sender: Any) {
        cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        request()
    }

    @IBAction func reloadRevalidatingCacheDataTapped(_ sender: Any) {
        cachePolicy = .reloadRevalidatingCacheData

        request()
    }
}

extension ViewController {
    @IBAction func clearLocalCookies(_ sender: Any) {
        let currentCookies = HTTPCookieStorage.shared.cookies ?? []
        currentCookies.forEach({ HTTPCookieStorage.shared.deleteCookie($0) })

        let alert = UIAlertController(
            title: "Local Cookie Cleared",
            message: "All Stored Cache cleared!",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)

        updateCookieField()
    }
}
