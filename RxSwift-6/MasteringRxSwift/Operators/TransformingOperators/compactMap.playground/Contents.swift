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
 # compactMap
 */

// compactMap: Observable이 방출하는 이벤트에서 값을 꺼낸다음 옵셔널 형태로 바꾸고 원하는 변환을 실행, 최종 변환 결과가 nil이면 해당 이벤트를 전달하지 않고 필터링함

let disposeBag = DisposeBag()

let subject = PublishSubject<String?>()

subject
//    .filter { $0 != nil }
//    .map { $0! }
    .compactMap { $0 } // 변환되는 값이 nil이면 필터링되고 아니면 언래핑돼서 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 결과를 subject로 전달
Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
    .take(10)
    .map { _ in Bool.random() ? "⭐️" : nil }
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: disposeBag)

