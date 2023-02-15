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
 # timer
 */
// timer: interval과 마찬가지로 정수를 반복적으로 방출하는 Observable 생성하지만 지연시간과 반복주기 모두 지정가능
// - 파라미터 -
// dueTime: 첫번째 요소가 방출되기까지의 상대적인 시간 (구독을 시작하고 첫번쨰 요소가 구독자에게 전달되기까지의 시간)
// period: 반복주기, 해당 값에 따라서 timer연산자의 동작 방식이 달라짐

let bag = DisposeBag()

// 첫번째 요소가 구독 후 1초뒤에 전달됨
Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

Observable<Int>.timer(.seconds(1), period: .milliseconds(500), scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { print($0) }
    .disposed(by: bag)





