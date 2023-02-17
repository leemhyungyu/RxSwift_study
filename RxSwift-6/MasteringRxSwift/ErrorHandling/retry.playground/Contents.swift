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
 # retry
 */
// retry는 error가 발생하면 Observable에 대한 구독을 해지하고 새로운 구독 시작
// --> 새로 구독하므로 OBservable의 모든 작업은 처음부터 다시 시작
// --> observable에서 에러가 발생하지 않으면 정상적으로 종료
// --> 에러가 발생하면 또 다시 새로운 구독 시작

let bag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("#\(currentAttempts) START")
    
    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }
    
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    
    return Disposables.create {
        print("#\(currentAttempts) END")
    }
}

source
//    .retry() // Observable이 정상적으로 완료할 때까지 계속해서 재시도 -> 리소스 낭비 문제
    .retry(7) // 마지막 재시도에서도 error이벤트가 전달되면 error이벤트를 전달하고 끝냄, 7번 재시도하고 싶으면 8을 파라미터로 전달해야 함
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 #1 START
 #1 END
 #2 START
 #2 END
 #3 START
 next(1)
 next(2)
 completed
 #3 END
 */



