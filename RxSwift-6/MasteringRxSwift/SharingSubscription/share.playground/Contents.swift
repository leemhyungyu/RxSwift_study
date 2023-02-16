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
 # share
 */
/*
let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().share() // share 연산자가 리턴하는 Observable은 refCountObservable임

let observer1 = source
    .subscribe { print("🔵", $0) }

// 2번째 구독자는 이전에 전달된 이벤트는 받지 못함
let observer2 = source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }

// 첫번째 구독자와 두번째 구독자는 동일한 Subject로부터 이벤트 받음
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    observer1.dispose()
    observer2.dispose()
    // 이후 Observable이 종료됨
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    // Observable에서 새로운 시퀀스 시작
    // 3번째 구독자의 첫번째 이벤트에는 0이 저장됨
    let observer3 = source.subscribe { print("⚫️", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer3.dispose()
    }
}
*/


/*
 2023-02-16 16:17:02.147: share.playground:32 (__lldb_expr_25) -> subscribed
 2023-02-16 16:17:03.161: share.playground:32 (__lldb_expr_25) -> Event next(0)
 🔵 next(0)
 2023-02-16 16:17:04.159: share.playground:32 (__lldb_expr_25) -> Event next(1)
 🔵 next(1)
 2023-02-16 16:17:05.159: share.playground:32 (__lldb_expr_25) -> Event next(2)
 🔵 next(2)
 2023-02-16 16:17:06.159: share.playground:32 (__lldb_expr_25) -> Event next(3)
 🔵 next(3)
 🔴 next(3)
 2023-02-16 16:17:07.159: share.playground:32 (__lldb_expr_25) -> Event next(4)
 🔵 next(4)
 🔴 next(4)
 2023-02-16 16:17:07.427: share.playground:32 (__lldb_expr_25) -> isDisposed
 2023-02-16 16:17:09.527: share.playground:32 (__lldb_expr_25) -> subscribed
 2023-02-16 16:17:10.529: share.playground:32 (__lldb_expr_25) -> Event next(0)
 ⚫️ next(0)
 2023-02-16 16:17:11.529: share.playground:32 (__lldb_expr_25) -> Event next(1)
 ⚫️ next(1)
 2023-02-16 16:17:12.529: share.playground:32 (__lldb_expr_25) -> Event next(2)
 ⚫️ next(2)
 2023-02-16 16:17:12.679: share.playground:32 (__lldb_expr_25) -> isDisposed

 */

/*
let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().share(replay: 5) // share 연산자가 리턴하는 Observable은 refCountObservable임

let observer1 = source
    .subscribe { print("🔵", $0) }

// 2번째 구독자는 구독이 시작되는 시점에 버퍼에 저장된 이벤트(이전의 전달된 이벤트)를 함께 전달받음
let observer2 = source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    observer1.dispose()
    observer2.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    // Observable에서 새로운 시퀀스 시작
    // 3번째 구독자의 첫번째 이벤트에는 0이 저장됨
    let observer3 = source.subscribe { print("⚫️", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer3.dispose()
    }
}

*/

let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().share(replay: 5, scope: .forever) // scope에 .forever를 전달하면 모든 구독자가 하나의 Subject를 공유

let observer1 = source
    .subscribe { print("🔵", $0) }

// 2번째 구독자는 구독이 시작되는 시점에 버퍼에 저장된 이벤트(이전의 전달된 이벤트)를 함께 전달받음
let observer2 = source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    observer1.dispose()
    observer2.dispose()
}

// 3번째 구독자도 구독이 시작되는 시점에 버퍼에 저장된 이벤트(이전의 전달된 이벤트)를 함께 받음
// 시퀀스가 중지된 다음에 새로운 구독자가 추가되면 새로운 시퀀스가 시작되기 때문에 이전의 저장된 이벤트와 새로운 이벤트 값이 추가로 받음
DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    let observer3 = source.subscribe { print("⚫️", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer3.dispose()
    }
}

/*
 2023-02-16 16:24:10.754: share.playground:117 (__lldb_expr_27) -> subscribed
 2023-02-16 16:24:11.758: share.playground:117 (__lldb_expr_27) -> Event next(0)
 🔵 next(0)
 2023-02-16 16:24:12.757: share.playground:117 (__lldb_expr_27) -> Event next(1)
 🔵 next(1)
 2023-02-16 16:24:13.755: share.playground:117 (__lldb_expr_27) -> Event next(2)
 🔵 next(2)
 🔴 next(0)
 🔴 next(1)
 🔴 next(2)
 2023-02-16 16:24:14.756: share.playground:117 (__lldb_expr_27) -> Event next(3)
 🔵 next(3)
 🔴 next(3)
 2023-02-16 16:24:15.756: share.playground:117 (__lldb_expr_27) -> Event next(4)
 🔵 next(4)
 🔴 next(4)
 2023-02-16 16:24:16.010: share.playground:117 (__lldb_expr_27) -> isDisposed
 ⚫️ next(0)
 ⚫️ next(1)
 ⚫️ next(2)
 ⚫️ next(3)
 ⚫️ next(4)
 2023-02-16 16:24:18.110: share.playground:117 (__lldb_expr_27) -> subscribed
 2023-02-16 16:24:19.111: share.playground:117 (__lldb_expr_27) -> Event next(0)
 ⚫️ next(0)
 2023-02-16 16:24:20.111: share.playground:117 (__lldb_expr_27) -> Event next(1)
 ⚫️ next(1)
 2023-02-16 16:24:21.111: share.playground:117 (__lldb_expr_27) -> Event next(2)
 ⚫️ next(2)
 2023-02-16 16:24:21.263: share.playground:117 (__lldb_expr_27) -> isDisposed
 */
