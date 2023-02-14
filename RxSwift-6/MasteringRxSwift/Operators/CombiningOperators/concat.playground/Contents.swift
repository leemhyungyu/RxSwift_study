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
 # concat
 */
// concat: 두 개의 Observable을 연결할 때 사용

let bag = DisposeBag()
let fruits = Observable.from(["🍏", "🍎", "🥝", "🍑", "🍋", "🍉"])
let animals = Observable.from(["🐶", "🐱", "🐹", "🐼", "🐯", "🐵"])

Observable.concat([fruits, animals])
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 next(🍏)
 next(🍎)
 next(🥝)
 next(🍑)
 next(🍋)
 next(🍉)
 next(🐶)
 next(🐱)
 next(🐹)
 next(🐼)
 next(🐯)
 next(🐵)
 completed
 */

// 대상 Observable이 Completed이벤트를 전달한 다음에 파라미터로 전달한 Observable을 연결함, 만약 Error이벤트가 전달된다면 Observable은 연결되지 않고 바로 종료

fruits.concat(animals)
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 next(🍏)
 next(🍎)
 next(🥝)
 next(🍑)
 next(🍋)
 next(🍉)
 next(🐶)
 next(🐱)
 next(🐹)
 next(🐼)
 next(🐯)
 next(🐵)
 completed
 next(🍏)
 next(🍎)
 next(🥝)
 next(🍑)
 next(🍋)
 next(🍉)
 next(🐶)
 next(🐱)
 next(🐹)
 next(🐼)
 next(🐯)
 next(🐵)
 completed
 */

animals.concat(fruits)
    .subscribe { print($0) }
    .disposed(by: bag)




