//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

final class 나중에생기는데이터<T> {
    private let task: (@escaping (T) -> Void) -> Void
    
    init(task: @escaping (@escaping (T) -> Void) -> Void) {
        self.task = task
    }
    
    func 나중에생기면(_ f: @escaping(T) -> Void) {
        task(f)
    }
}

final class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // MARK: SYNC
    
        func downloadJson(_ url: String) -> 나중에생기는데이터<String?> {
            return 나중에생기는데이터 { f in
                DispatchQueue.global().async {
                    let url = URL(string: MEMBER_LIST_URL)!
                    let data = try! Data(contentsOf: url)
                    let json = String(data: data, encoding: .utf8)
                    DispatchQueue.main.async {
                        f(json)
                    }
                }
            }
        }
    
    
    func downloadJson2(_ url: String) -> Observable<String?> {
        Observable.create { observer in
            observer.onNext("Hello")
            observer.onNext("world")
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func downloadJson3(_ url: String) -> Observable<String> {
        Observable.create { observer in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
                guard err == nil else {
                    observer.onError(err!)
                    return
                }
                
                if let safedata = data, let json = String(data: safedata, encoding: .utf8) {
                    observer.onNext(json)
                }
                
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
    }

    
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
        
//        방법 1
//        let json: 나중에생기는데이터<String?> = downloadJson(MEMBER_LIST_URL)
//
//        json.나중에생기면 { json in
//            self.editView.text = json
//            self.setVisibleWithAnimation(self.activityIndicator, false)
//        }
//
//        방법 2
//        downloadJson2(MEMBER_LIST_URL)
//            .subscribe { event in
//                switch event {
//                case .next(let json):
//                    self.editView.text = json
//                    self.setVisibleWithAnimation(self.activityIndicator, false)
//                case .error(let err):
//                    print(err)
//                case .completed:
//                    print("complete")
//                }
//            }
        
//        방법3
//        downloadJson3(MEMBER_LIST_URL)
//            .observeOn(MainScheduler.instance)
//            .subscribe( onNext: { json in
//                self.editView.text = json
//                self.setVisibleWithAnimation(self.activityIndicator, false)
//            })
        
        let jsonObservable = downloadJson3(MEMBER_LIST_URL)
        let helloObservable = Observable.just("Hello World")
        
        Observable.zip(jsonObservable, helloObservable) { $1 + "\n" + $0 }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { str in
                self.editView.text = str
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
            
    }
}
