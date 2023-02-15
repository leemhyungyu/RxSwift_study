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
 # delay
 */
// delay: Next이벤트가 구독자로 전달되는 시점을 지정한 시간만큼 지연시킴
// --> 구독 시점을 지연시키는것은 아님
// --> 구독 시점을 딜레이 시키려면 delaySubscription사용

let bag = DisposeBag()

func currentTimeString() -> String {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return f.string(from: Date())
}

// 원본 Observable이 방출한 Next이벤트가 5초뒤에 전달됨
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(10)
    .debug()
    .delay(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: bag)


/*
 2023-02-16 00:33:16.455: delay.playground:41 (__lldb_expr_166) -> subscribed
 2023-02-16 00:33:17.468: delay.playground:41 (__lldb_expr_166) -> Event next(0)
 2023-02-16 00:33:18.467: delay.playground:41 (__lldb_expr_166) -> Event next(1)
 2023-02-16 00:33:19.466: delay.playground:41 (__lldb_expr_166) -> Event next(2)
 2023-02-16 00:33:20.466: delay.playground:41 (__lldb_expr_166) -> Event next(3)
 2023-02-16 00:33:21.465: delay.playground:41 (__lldb_expr_166) -> Event next(4)
 2023-02-16 00:33:22.466: delay.playground:41 (__lldb_expr_166) -> Event next(5)
 2023-02-16 00:33:22.473 next(0)
 2023-02-16 00:33:23.466: delay.playground:41 (__lldb_expr_166) -> Event next(6)
 2023-02-16 00:33:23.478 next(1)
 2023-02-16 00:33:24.466: delay.playground:41 (__lldb_expr_166) -> Event next(7)
 2023-02-16 00:33:24.480 next(2)
 2023-02-16 00:33:25.466: delay.playground:41 (__lldb_expr_166) -> Event next(8)
 2023-02-16 00:33:25.482 next(3)
 2023-02-16 00:33:26.466: delay.playground:41 (__lldb_expr_166) -> Event next(9)
 2023-02-16 00:33:26.466: delay.playground:41 (__lldb_expr_166) -> Event completed
 2023-02-16 00:33:26.466: delay.playground:41 (__lldb_expr_166) -> isDisposed
 2023-02-16 00:33:26.484 next(4)
 2023-02-16 00:33:27.486 next(5)
 2023-02-16 00:33:28.488 next(6)
 2023-02-16 00:33:29.489 next(7)
 2023-02-16 00:33:30.491 next(8)
 2023-02-16 00:33:31.493 next(9)
 2023-02-16 00:33:31.494 completed
 */

