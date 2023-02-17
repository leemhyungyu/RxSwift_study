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
 # catch(_:)
 */
// 에러처리 방법
// Observable에서 Error이벤트를 방출하면 구독이 종료하고 구독자는 새로운 이벤트 받지 못함
// ex) Observable -> 네트워크 요청 처리, 구독자 -> UI를 업데이트
// 에러이벤트가 전달되면 구독이 종료되고 이벤트가 전닫되지 않으므로 UI 업데이트가 안됨
// RxSwift는 두가지 방법으로 해당 문제 해결
// 1. catch 연산자 사용
// --> catch연산자는 Next, Completed 이벤트는 구독자에게 전달
// --> error 이벤트가 전달되면 새로운 Observable 리턴
// --> 네트워크 에러가 났을 때 기본값이나 새로운 Observable 방출해 UI업데이트 가능
// 2. retry 연산자 사용
// --> error 이벤트가 전달되면 Observable을 다시 구독(무한정 or 횟수 제한)

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .catch{  _ in recovery } // SourceObservable이 방출한 Error를 새로운 Observable로 교체하는 방식으로 처리
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onError(MyError.error)
subject.onNext(123) // 구독자에게 전달 X
subject.onNext(11) // 구독자에게 전달 X

recovery.onNext(22) // 구독자에게 전달
recovery.onCompleted()

/*
 에러가 발생했을 떄 기본값이 있다면 catchAndReturn
 하지만, 에러의 종류에 관계없이 항상 동일한 값을 리턴한다는 단점
 나머지 경우에는 catch 연산자 사용 -> 클로저를 통해 error 처리 코드를 자유롭게 구현 가능
 */
