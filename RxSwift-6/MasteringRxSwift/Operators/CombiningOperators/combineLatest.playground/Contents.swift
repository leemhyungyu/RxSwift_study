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
 # combineLatest
 */
// combineLatest: Source Observable을 결합한다음 파라미터로 전달한 함수를 실행하고 결과를 방출하는 새로운 Observable을 리턴
// --> 연산자가 리턴한 Observable이 언제 이벤트를 방출하는지 이해하는것이 중요
// --> 각 Source Observable의 최신값과 결합

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let greetings = PublishSubject<String>()
let languages = PublishSubject<String>()

Observable.combineLatest(greetings, languages) { lhs, rhs -> String in
    return "\(lhs) \(rhs)"
}
    .subscribe { print($0) }
    .disposed(by: bag)

greetings.onNext("Hi")
languages.onNext("World!")
greetings.onNext("Hello")
languages.onNext("RxSwift")

greetings.onCompleted()

languages.onNext("Swift")

languages.onCompleted()

// 모든 Observable이 Completed이벤트를 전달하면 해당 시점에 구독자에게 Completed이벤트 전달

// Soruce Observable에서 하나라도 Error을 전달하면 그 즉시 Error이벤트 전달하고 종료

/*
 next(Hi World!)
 next(Hello World!)
 next(Hello RxSwift)
 next(Hello Swift)
 completed
 */



