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
 # buffer
 */
// buffer: 특정 주기 동안 Observable이 방출하는 항목을 수집하고 하나의 배열로 리턴 -> controlled buffering이라고도 함

let disposeBag = DisposeBag()

// timeSpan: 항목을 수집할 시간(해당 시간마다 수집되어있는 항목을 배출)
// count: 수집할 항목의 숫자(해당 숫자보다 적은 항목을 수집했더라도 시간이 경과하면 수집한 수만큼 방출)

//Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//    .buffer(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
//    .take(5)
//    .subscribe { print($0) }
//    .disposed(by: disposeBag)


/*
 next([0])
 next([1, 2, 3]) // 시간상의 오차
 next([4, 5])
 next([6, 7])
 next([8, 9])
 completed
 */


// timeSpan만큼 시간이 지나지 않았어도 수집할 숫자가 꽉차면 방출함
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { print($0) }
    .disposed(by: disposeBag)


/*
 next([0, 1, 2])
 next([3, 4, 5])
 next([6, 7, 8])
 next([9, 10, 11])
 next([12, 13, 14])
 completed
 */






