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
 # ReplaySubject
 */
// ReplaySubject: 하나 이상의 최신 이벤트를 버퍼에 저장, Observer가 구독을 시작하면 버퍼에 있는 모든 이벤트 전달

// BehaviorSubject는 가장 최신의 이벤트만 남기고 나머지 이벤트들은 사라짐 -> 따라서 2개 이상의 이벤트를 저장해두고 구독자에게 전달하고 싶다면 ReplaySuject 사용
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// PublishSubject와 BehaviorSubject와 달리 create로 subject 생성하고 버퍼 사이즈(이벤트 개수) 명시해야함
let rs = ReplaySubject<Int>.create(bufferSize: 3)

(1...10).forEach { rs.onNext($0) }

// Next이벤트로 8, 9, 10 전달됨
rs.subscribe { print("Observer 1 >>", $0) }
    .disposed(by: disposeBag)

// 마찬가지로 8, 9, 10 전달됨
rs.subscribe { print("Observer 2 >>", $0) }
    .disposed(by: disposeBag)

rs.onNext(11) // 새로운 이벤트를 전달하게 되면 버퍼에 저장되어있는 이벤트 중 가장 오래된 이벤트를 삭제함

// Next이벤트로 9, 10, 11가 전달 됨
rs.subscribe { print("Observer 3 >>", $0) }
    .disposed(by: disposeBag)

rs.onCompleted() // 모든 구독자에게 completed 이벤트 전달
rs.onError(MyError.error) // 모든 구독자에게 error 이벤트 전달

// 버퍼에 저장되어있는 이벤트가 전달된 다음에 completed(또는 error)이벤트가 전달됨
rs.subscribe { print("Observer 4 >>", $0) }
    .disposed(by: disposeBag)


// :- ReplaySubject의 버퍼는 메모리에 저장되기 때문에 항상 메모리에 신경써야함. 필요 이상으로 큰 버퍼를 사용하는것은 피해야 한다.


