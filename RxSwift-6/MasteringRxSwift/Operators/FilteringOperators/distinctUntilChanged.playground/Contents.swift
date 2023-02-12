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
 # distinctUntilChanged
 */
// distinctUntilChanged: 다음 이벤트가 이전 이벤트와 동일하다면 방출하지 않음, 그리고 이벤트를 비교할떄는 비교 연산자를 사용해 포함되어있는 값을 비교

struct Person {
    let name: String
    let age: Int
}

let disposeBag = DisposeBag()
let numbers = [1, 1, 3, 2, 2, 3, 1, 5, 5, 7, 7, 7]
let tuples = [(1, "하나"), (1, "일"), (1, "one")]
let persons = [
    Person(name: "Sam", age: 12),
    Person(name: "Paul", age: 12),
    Person(name: "Tim", age: 56)
]


Observable.from(numbers)
    .distinctUntilChanged() // 해당 연산자가 이전과 같은 이벤트를 무시함
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 - 출력 -
 next(1)
 next(3)
 next(2)
 next(3)
 next(1)
 next(5)
 next(7)
 completed
 */

// comparer: 클로저이며 Observable이 방출한 Next이벤트에 포함된 값을 파라미터로 받음
Observable.from(numbers)
    .distinctUntilChanged { !$0.isMultiple(of: 2) && !$1.isMultiple(of: 2) } // 둘다 홀수 일때만 true리턴, false만 방출 -> 연속된 홀수를 방출하지 않음, 짝수는 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(1)
 next(2)
 next(2)
 next(3)
 completed
 */

// keySelector: 클로저를 파라미터로 받고, Next이벤트에 포함된 값 하나가 포함됨
Observable.from(tuples)
    .distinctUntilChanged { $0.0 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next((1, "하나"))
 completed
 */

Observable.from(tuples)
    .distinctUntilChanged { $0.1 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next((1, "하나"))
 next((1, "일"))
 next((1, "one"))
 completed
 */

// keyPath로 속성을 지정해서 사용
Observable.from(persons)
    .distinctUntilChanged(at: \.age)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(Person(name: "Sam", age: 12))
 next(Person(name: "Tim", age: 56))
 completed
 */
