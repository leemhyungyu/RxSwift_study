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
 # BehaviorSubject
 */
// BehavirSubject: 생성 시점에 시작 이벤트를 지정, Subject로 전달되는 이벤트 중에서 가장 마지막에 전달되는 최신 이벤트를 저장했다가 새로운 구독자에게 최신 이벤트 전달


let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let p = PublishSubject<Int>()

// PublishSubject는 내부에 이벤트가 저장되지 않은 상태로 생성되기 때문에 subject로 이벤트가 전달되기 전까지 구독자로 이벤트가 전달되지 않음
p.subscribe { print("PublishSubject >>", $0) }
    .disposed(by: disposeBag)


// BehaviorSubject를 생성할 떄 생성자로 전달한 값으로 내부에 Next이벤트가 만들어짐
// 새로운 구독자가 추가되면 저장되어있는 Next이벤트가 바로 전달됨
let b = BehaviorSubject<Int>(value: 0) // 하나의 값을 전달.

b.subscribe { print("BehaviorSubject1 >>", $0) }
    .disposed(by: disposeBag)

b.onNext(1)

// 최신으로 생성된 이벤트를 저장했다가 새로운 구독자에게 이벤트 전달
b.subscribe { print("BehaviorSubject2 >>", $0) }
    .disposed(by: disposeBag)

b.onCompleted()
// 모든 구독자에게 completed이벤트 전달
/*
 BehaviorSubject1 >> completed
 BehaviorSubject2 >> completed
 BehaviorSubject3 >> completed
 */

b.onError(MyError.error) // 모든 구독자에게 Error이벤트 전달

b.subscribe { print("BehaviorSubject3 >>", $0) }
    .disposed(by: disposeBag)




