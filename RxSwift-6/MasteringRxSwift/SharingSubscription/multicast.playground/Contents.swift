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
 # multicast
 */
// multicast는 ConnectableObservable을 리턴, 해당 Observable은 일반 Observable과 다르게 시퀀스가 시작되는 시점이 다름 (구독자가 추가되어도 시퀀스가 시작되지 않고 Connect메소드를 호출하는 시점에 시퀀스가 시작) -> 모든 구독자가 등록된 이후에 하나의 시퀀스를 시작하는 패턴을 구현할 수 있음

let bag = DisposeBag()
let subject = PublishSubject<Int>()

// 1초 주기로 5개의 정수를 방출하는 Observable
// 원본 Observable에서 시퀀스가 시작되고 모든 이벤트는 파라미터로 전달한 subject로 전달함 -> 해당 subject는 등록된 모든 구독자에게 이벤트를 전달함 -> 이 모든 과정은 connect 메소드가 호출되는 시점에 시작
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).multicast(subject)

// multicast를 사용하지 않으면 Observable에 구독자를 추가하면 새로운 시퀀스가 추가됨 -> 각각의 시퀀스가 개별적으로 실행되었고 서로 공유되지 않음

/*
 🔵 next(0)
 🔵 next(1)
 🔵 next(2)
 🔴 next(0)
 🔵 next(3)
 🔴 next(1)
 🔵 next(4)
 🔴 next(2)
 🔵 completed
 🔴 next(3)
 🔴 next(4)
 🔴 completed
 */

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance) // 구독 시점을 3초 지연
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect() // connect 메소드를 호출해 시퀀스 시작

/*
 🔵 next(0)
 🔵 next(1)
 🔵 next(2)
 🔴 next(2)
 🔵 next(3)
 🔴 next(3)
 🔵 next(4)
 🔴 next(4)
 🔵 completed
 🔴 completed
 */





















