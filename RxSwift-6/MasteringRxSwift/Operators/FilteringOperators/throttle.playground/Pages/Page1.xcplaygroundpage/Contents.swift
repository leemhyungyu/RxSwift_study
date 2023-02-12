//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # throttle
 */

let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
   DispatchQueue.global().async {
      for i in 1...10 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.3)
      }
      
      Thread.sleep(forTimeInterval: 1)
      
      for i in 11...20 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.5)
      }
      
      observer.onCompleted()
   }
   
   return Disposables.create {
      
   }
}

// 원본 Observable에서 방출되는 Next가 1초마다 구독자에게 전달
buttonTap
    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(Tap 1)
 next(Tap 4)
 next(Tap 7)
 next(Tap 10)
 next(Tap 11)
 next(Tap 12)
 next(Tap 14)
 next(Tap 16)
 next(Tap 18)
 next(Tap 20)
 completed
 */

// throttle: Next이벤트를 지정된 주기마다 하나씩 구독자에게 전달
// debounce: Next이벤트를 전달한 다음 지정된 시간이 경과하기까지 다른 이벤트가 전달되지 않는다면 마지막으로 방출된 이벤트를 구독자에게 전달
// -> 주로 검색 기능 구현시 활용, 키워드를 입력시 네트워크 요청 전달과 같이..
// -> 사용자가 짧은 시간동안 연속해서 입력할때는 작업이 실행되지 않다가 지정된 시간동안 입력되지 않으면 검색 시작. 불필요한 리소스 낭비하지않고 실시간 검색 기능 구현 가능
//: [Next](@next)
