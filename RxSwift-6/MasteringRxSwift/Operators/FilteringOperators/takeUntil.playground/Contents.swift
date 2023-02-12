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
 # take(until:)
 */

let disposeBag = DisposeBag()


let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

// 파라미터로 전달한 Observable에서 onNext이벤트가 방출하기 전까지 원본 Observable이 방출하는 이벤트를 그대로 전달

subject.take(until: trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)

trigger.onNext(0)

subject.onNext(3)

/*
 - 출력 -
 next(1)
 next(2)
 completed

 */

// 클로저에서 false를 리턴하는 동안 이벤트 방출, true를 리턴하면 이벤트 방출을 중단하고 Observable 종료

subject.take(until: { $0 > 5 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)
subject.onNext(3)
subject.onNext(6)


/*
 - 출력 -
 next(1)
 next(2)
 next(3)
 completed

 */










