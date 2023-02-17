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
 # Scheduler
 */
// CurrentThreadScheduler: 스케줄러를 별도로 지정하지 않으면 해당 스케줄러가 사용됨
// MainScheduler: UI 업데이트 시 사용
// 작업을 실행할 DispatchQueue를 직집 지정해주고 싶다면 SerialDispatchQeueScheduler나 ConcurrentDispatchQueueScheduler를 사용함
// 실행 순서를 제외하거나 동시에 실행가능한 작업 수를 제한하고 싶다면 OperationQeueScheduler를 사용함

/*
 -: 스케줄러를 올바르게 사용하기 위해서는 두 가지가 중요
 1. Observable이 생성되는 시점을 이해 -> 구독이 시작되는 시점
 2. 스케줄러를 지정하는 방법 -> 지정하지 않으면 CurrentScheduler가 사용 (MainThread)
 
    --> observeOn(), subscribeOn() 메소드 사용
    --> observeOn(): 이어지는 연산자들이 실행할 스케줄러 지정
    --> subscribeOn(): 구독을 시작하고 종료할 때 사용할 스케줄러 지정 (Observable이 시작되는 스케줄러를 지정), 구독을 시작하면 Observable에서 이벤트를 방출할 스케줄러를 지정하는 것, create연산자로 구현한 코드도 마찬가지로 subscribeOn()메소드에서 지정한 스케줄러에서 실행됨, subscribeOn()메소드를 사용하지 않으면 subscribe메소드가 호출된 스케줄러에서 새로운 시퀀스가 시작됨
        ** subscribe메소드가 호출되는 스케줄러를 지정하는게 아니고 이어지는 연산자가 호출되는 스케줄러를 지정하는 것도 아님, Observable이 시작되는 시점에 어떤 스케줄러를 사용할지 지정하는 것
*/

let bag = DisposeBag()

let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .subscribe(on: MainScheduler.instance) // 위치는 상관없음
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observe(on: backgroundScheduler) // map 연산자를 실행할 스케줄러를 background스케줄러로 지정
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .observe(on: MainScheduler.instance)
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: bag)

/*
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Background Thread >> subscribe
 Main Thread >> filter
 next(4)
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Background Thread >> subscribe
 next(8)
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Background Thread >> subscribe
 next(12)
 Background Thread >> map
 Background Thread >> subscribe
 next(16)
 Background Thread >> subscribe
 completed
 */
