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
import RxCocoa

/*:
 # Relay
 */
// :- RxSwift는 Subject를 래핑하고 있는 세 가지 Relay 제공
// :- Relay는 일반적인 Subject와 달리 Next이벤트만 받고 나머지 Completed와 Error이벤트 받지 않아 종료되지 않음. 주로 종료없이 계속 전달되는 이벤트 시퀀스를 처리할 때 사용 -> UI이벤트 처리
// PublishRelay: PublishSubject를 래핑한 것
// BehaviorRelay: BehaviorSubject를 래핑한 것
// ReplayRelay: ReplaySubject를 래핑한 것

let bag = DisposeBag()

let prelay = PublishRelay<Int>()

prelay.subscribe { print("1: \($0)") }
    .disposed(by: bag)

// :- Relay로 Next이벤트를 전달할 때는 accept메소드 사용
prelay.accept(1)

let brelay = BehaviorRelay(value: 1)

brelay.accept(2) // 내부에 저장된 next이벤트가 2로 교체됨

brelay.subscribe { print("2: \($0)") }
    .disposed(by: bag)

brelay.accept(3)

// :- BehaviorRelay의 value 속성: Relay가 저장하고 있는 Next이벤트에 접근해서 해당 값을 리턴, 읽기 전용임

print(brelay.value)

let rrelay = ReplayRelay<Int>.create(bufferSize: 3)

(1...10).forEach { rrelay.accept($0) }

// 8, 9, 10이 onNext이벤트로 전달
rrelay.subscribe { print("3: \($0)") }
    .disposed(by: bag)



