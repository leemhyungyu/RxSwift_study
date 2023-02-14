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
 # switchLatest
 */
// switchLatest: 가장 최근 Observable이 방출하는 이벤트를 구독자에게 전달
// --> 어떤 Observable이 가장 최근 Observable인지 이해하는게 핵심

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()

// 문자열을 방출하는 Observable을 방출하는 Subject
let source = PublishSubject<Observable<String>>()

source
    .switchLatest()
    .subscribe { print($0) }
    .disposed(by: bag)

a.onNext("1")
b.onNext("b")

source.onNext(a) // a가 최신 Observable

a.onNext("2")
b.onNext("b")

source.onNext(b) // db가 최신 Observable, a에 대한 구독 종료하고 b를 구독

a.onNext("3")
b.onNext("c")

a.onCompleted() // 구독자로 전달되지 않음
b.onCompleted() // 마찬가지로 전달되지 않음

source.onCompleted() // 구독자로 전달


/*
 next(2)
 next(c)
 completed
 */

a.onError(MyError.error) // 구독자로 전달되지 않음
b.onError(MyError.error) // 최신 Observable인 b는 구독자에게 전달
