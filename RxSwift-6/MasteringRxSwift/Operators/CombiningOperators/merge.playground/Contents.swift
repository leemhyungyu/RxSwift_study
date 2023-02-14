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
 # merge
 */
// merge: 여러 Observable이 배출하는 항목들을 하나의 Observable에서 방출하도록 병합, concat연산자와 혼동 주의
// --> 두개 이상의 Observable을 병합하고 모든 Observable에서 방춣하는 요소들을 순서대로 방출하는 Observable 리턴

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let oddNumbers = BehaviorSubject(value: 1)
let evenNumbers = BehaviorSubject(value: 2)
let negativeNumbers = BehaviorSubject(value: -1)

var source = Observable.of(oddNumbers, evenNumbers)

// 2개의 subject 방출
source.subscribe { print($0) }
    .disposed(by: bag)

/*
 next(RxSwift.BehaviorSubject<Swift.Int>)
 next(RxSwift.BehaviorSubject<Swift.Int>)
 completed
 */

// subject가 방출한 항목 방출
source
    .merge()
    .subscribe { print($0) }
    .disposed(by: bag)

oddNumbers.onNext(3)
evenNumbers.onNext(4)

evenNumbers.onNext(6)
oddNumbers.onNext(5)

//oddNumbers.onCompleted() // 해당 subject는 더이상 새로운 이벤트를 받지 않음
//oddNumbers.onError(MyError.error) // 병합 대상중에서 하나라도 error이벤트를 전달하면 나머지 suject에서 방출한 이벤트도 더 이상 전달하지 않음

evenNumbers.onNext(8)
evenNumbers.onCompleted() // 최종적으로 구독자에게 completed이벤트가 전달

/*
 next(1)
 next(2)
 next(3)
 next(4)
 next(6)
 next(5)
 next(8)
 completed
 */

source = Observable.of(oddNumbers, evenNumbers, negativeNumbers)

source
    .merge(maxConcurrent: 2) // 병합 가능한 Observable 개수 제한
    .subscribe { print($0) }
    .disposed(by: bag)


negativeNumbers.onNext(-2) // 병합 대상에 제외돼서 전달되지 않음
oddNumbers.onCompleted() // 병합 대상에서 제외돼서 negativeNumbers가 병합대상에 포함됨






