//: [Previous](@previous)

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


import Foundation
import RxSwift


/*:
 # throttle
 ## latest parameter
 */

let disposeBag = DisposeBag()

func currentTimeString() -> String {
   let f = DateFormatter()
   f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
   return f.string(from: Date())
}


// 1초마다 정수를 방출하는 Observable에서 2.5주기를 가진 throttle연산자 사용
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
   .debug()
   .take(10)
   .throttle(.milliseconds(2500), latest: true, scheduler: MainScheduler.instance) // true -> 주기를 엄격하게 지킴
   .subscribe { print(currentTimeString(), $0) }
   .disposed(by: disposeBag)

/*
 next(0)
 next(2)
 next(5)
 next(7)
 next(9)
 completed
 */

// throttle의 주기가 지나도 원본 Observable이 새로운 Next이벤트를 방출할 떄까지 기다림 -> 마지막 이벤트 전달
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
   .debug()
   .take(10)
   .throttle(.milliseconds(2500), latest: false, scheduler: MainScheduler.instance) // false -> 지정된 주기를 초과할 수 있음
   .subscribe { print(currentTimeString(), $0) }
   .disposed(by: disposeBag)

/*
 next(0)
 next(3)
 next(6)
 next(9)
 completed
 */
