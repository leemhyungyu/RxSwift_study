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
 # PublishSubject
 */
// -: Observable은 다른 Observable을 구독 X
// -: Observer는 다른 Observer로 이벤트를 전달하지 못함
// Subject: 다른 Observable로 부터 이벤트를 받아서 observer로 전달, Observable인 동시에 Observer임

// PublishSubject: Subject로 전달되는 새로운 이벤트를 구독자(Observer)로 전달
// BehavirSubject: 생성 시점에 시작 이벤트를 지정, Subject로 전달되는 이벤트 중에서 가장 마지막에 전달되는 최신 이벤트를 저장했다가 새로운 구독자에게 최신 이벤트 전달
// ReplaySubject: 하나 이상의 최신 이벤트를 버퍼에 저장, Observer가 구독을 시작하면 버퍼에 있는 모든 이벤트 전달
// AsyncSubject: Subject로 Completed 이벤트가 전달되는 시점에 마지막으로 전달된 Next 이벤트를 구독자로 전달

// :- RxSwift는 Subject를 래핑하고 있는 두가지 Relay 제공
// :- Relay는 일반적인 Subject와 달리 Next이벤트만 받고 나머지 COmpleted와 Error이벤트 받지 않음. 주로 종료없이 계속 전달되는 이벤트 시퀀스를 처리할 때 사용
// PublishRelay: PublishSubject를 래핑한 것
// BehaviorRelay: BehaviorSubject를 래핑한 것


let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<String>() // 문자열이 포함된 Next이벤트를 받아서 다른 Observer에 전달하는 PublishSubject

subject.onNext("Hello") // subject를 구독하는 observer가 없기 떄문에 onNext이벤트는 처리되지않고 사라짐

// :- PublishSubject는 구독 이후에 전달되는 새로운 이벤트만 구독자로 전달
// 따라서 이전의 onNext이벤트는 o1으로 전달되지 않음
let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag)

subject.onNext("RxSwift") // subject는 해당 이벤트를 구독자에 전달

// 위와 마찬가지로 o2가 구독하기 전의 이벤트는 전달되지 않음
let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject") // o1와 o2에게 전달됨

subject.onCompleted()
//subject.onError(MyError.error)

// :- subject가 onCompleted를 호출하고 완료가 된 이후에 새로운 구독자가 추가되면 completed이벤트가 전달됨, 새로운 구독자에게 전달할 Next이벤트가 없기 때문에 completed이벤트를 전달해서 종료함

let o3 = subject.subscribe { print(">> 3", $0) }
o3.disposed(by: disposeBag)

// :- subject로 error이벤트가 전달되는 경우도 마찬가지로 모든 구독자에게 Error이벤트가 전달됨
// :- PublishSubject는 이벤트가 전달되면 즉시 구독자에게 전달함, 그래서 Subject가 최초로 생성되는 시점과 첫 번째 구독이 시작되는 시점 사이에 전달되는 이벤트는 사라지게 됨.
// :- 이벤트를 사라지게 하지 않기 위해서는 ReplaySubject를 사용
