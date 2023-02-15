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
 # timeout
 */

// timeout: 지정된 시간 이내에 요소를 방출하지 않으면 에러 이벤트를 전달



let bag = DisposeBag()

let subject = PublishSubject<Int>()

// 해당 시간안에 Next이벤트를 전달하지 않으면 Error이벤트를 전달하고 종료함
subject.timeout(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

// timeout 시간내에 Next이벤트가 전달되므로 구독자에게 전달되고 Error이벤트가 전달되지 않음
Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)

// 첫번째 이벤트만 전달되고 다음 이벤트는 전달되지 않고 Error 이벤트 전달
Observable<Int>.timer(.seconds(2), period: .seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)

// timeout이 발생하면 other 파라미터로 받은 Observable로 구독 대상이 변경됨 -> 해당 Observable에서 전달한 이벤트가 구독자에게 전달되고 completed이벤트가 전달되고 구독이 종료됨
subject.timeout(.seconds(3), other: Observable.just(0), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)
