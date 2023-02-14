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
 # zip
 */
// zip: Soruce Observable이 방출하는 요소를 결합, 결합하는 점에서는 combineLatest와 동일하지만 클로저에게 중복된 요소를 전달하지 않고 반드시 인덱스를 기준으로 짝을 일치시켜서 전달
// --> 첫번째 요소는 첫번째 요소와 결합, 두번째 요소는 두번째 요소와 결합
// --> 결합할 짝이 없는 요소들은 구독자에게 전달되지 않음
// --> 해당 방식을 indexed Sequencing이라 함

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let numbers = PublishSubject<Int>()
let strings = PublishSubject<String>()

Observable.zip(numbers, strings) { "\($0) - \($1)" }
    .subscribe { print($0) }
    .disposed(by: bag)

// 항상 방출된 순서대로 짝을 맞춤

numbers.onNext(1)
strings.onNext("one")

numbers.onNext(2)
strings.onNext("two")

numbers.onCompleted()

//numbers.onNext(MyError.error) // 하나라도 error이벤트를 전달하면 즉시 구독자에게 error이벤트가 전달되고 종료

strings.onNext("three") // 해당 이벤트가 구독자에게 전달되지 않음

strings.onCompleted() // 모든 Source Observable이 completed이벤트를 전달하면 최종적으로 구독자에게 completed이벤트가 전달됨

/*
 next(1 - one)
 next(2 - two)
 completed

 */





