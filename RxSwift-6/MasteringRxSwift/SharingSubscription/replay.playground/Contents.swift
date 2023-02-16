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
 # replay, replayAll
 */

// RelaySubject를 이용해 두 번째 구독자가 이전의 발생한 이벤트를 함께 전달받음
let bag = DisposeBag()
let subject = ReplaySubject<Int>.create(bufferSize: 5)
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).multicast(subject)

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect()

/*
  🔵 next(0)
  🔵 next(1)
  🔴 next(0)
  🔴 next(1)
  🔵 next(2)
  🔴 next(2)
  🔵 next(3)
  🔴 next(3)
  🔵 next(4)
  🔴 next(4)
  🔵 completed
  🔴 completed
 */

// replay 연산자를 사용할 때는 항상 버퍼 크기를 신중하게 지정해야 함(메모리 문제)
// 버퍼 크기에 제한이 없는 replayAll연산자는 가능하면 사용 X
let s = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).replay(5)

s
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

s
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect()

/*
 🔵 next(0)
 🔵 next(1)
 🔴 next(0)
 🔴 next(1)
 🔵 next(2)
 🔴 next(2)
 🔵 next(3)
 🔴 next(3)
 🔵 next(4)
 🔴 next(4)
 🔵 completed
 🔴 completed
 */
















