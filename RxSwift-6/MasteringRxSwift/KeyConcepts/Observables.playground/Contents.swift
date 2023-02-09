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
 # Observables
 */

// 두 개의 정수를 방출하고 종료하는 Observable 생성
// 이벤트가 전달되는 시점은 Observer가 구독을 시작하는 시점
// Observable: 이벤트를 observer로 전달, 이벤트가 전달되는 순서를 정의
// Observer: Observable에서 전달되는 이벤트 처리(구독) -> 실제 이벤트가 전달되는 시간은 Observer가 (subscribe 메소드를 통해) 구독 시작하는 순간

// #1 create 연산자를 통해 Observable 동작을 직접 구현
Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)

    observer.onCompleted() // completed이벤트가 전달되고 옵저버블 종료

    return Disposables.create()
}

// #2 from 연사자를 통해 Observable 생성
Observable.from([0, 1])

// #3 1에서 만들었던 Observable을 통해 observer로 이벤트 처리
let o1 = Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    
    observer.onCompleted() // completed이벤트가 전달되고 옵저버블 종료
    
    return Disposables.create()
}

// 하나의 클로저(옵저버 역할)를 통해 모든 이벤트 처리
o1.subscribe {
    print($0)
    
    if let element = $0.element {
        print(element)
    }
}

// 개별 이벤트를 별도의 클로저에서 처리
o1.subscribe(onNext: { element in
    print(element) // next이벤트에 저장된 요소만 출력
})

// Observer는 동시에 2개 이상의 이벤트 처리 X
// Observable은 Observer가 하나의 이벤트를 처리한 후에 이어지는 이벤트 전달, 여러 이벤트 동시에 전달 X
