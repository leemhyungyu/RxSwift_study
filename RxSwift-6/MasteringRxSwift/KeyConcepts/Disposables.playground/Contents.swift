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
 # Disposables
 */

// 3개의 정수를 방출하는 Observable
Observable.from([1, 2, 3])
    .subscribe { element in
        print("Next", element)
    } onError: { error in
        print("Error", error)
    } onCompleted: {
        print("Completed")
    } onDisposed: {
        // -: Disposed는 Observable이 전달하는 이벤트는 아니지만 파라미터로 클로저를 전달하면 Observable과 관련된 모든 리소스가 제거된 후에 호출
        print("Disposed")
    }

Observable.from([1, 2, 3])
    .subscribe { // 하나의 클로저에서 모든 이벤트 처리
        print($0)
    }

// 해당 Observable은 Disposed가 출력되지 않음 -> 리소스가 해지되지 않았을까?
// 옵저저블이 Completed이벤트나 Error이벤트로 종료되었다면 관련된 리소스가 자동으로 해지된다.
// 그런데 왜 Disposed가 출력되지 않았을까?
// --> Disposed는 옵저버블이 전달하는 이벤트가 아님.
// 첫번째 Observable처럼 onDisposed파라미터로 클로저를 전달하면 리소스가 호출되는 시점에 자동으로 호출되는 것 뿐. 따라서 리소스가 해지되는 시점에 어떤 코드를 실행하고싶다면 첫번째처럼 아니라면 두번째처럼
// 하지만 두번째와 같은 경우에도 Disposed를 통해 리소스 정리해야함 (RxSwfit 권고)

let subscription1 = Observable.from([1, 2, 3])
    .subscribe { element in
        print("Next", element)
    } onError: { error in
        print("Error", error)
    } onCompleted: {
        print("Completed")
    } onDisposed: {
        print("Disposed")
    }

subscription1.dispose()

// :- Dispose를 직접 호출하는 것보다 DisposeBag 사용을 권고

var bag = DisposeBag() // DisposeBag에 disposable을 담았다가 한번에 해지

Observable.from([1, 2, 3])
    .subscribe { // 하나의 클로저에서 모든 이벤트 처리
        print($0)
    }
    .disposed(by: bag) // 해당 방식처럼 파라미터로 DisposeBag을 전달하면 subscribe가 리턴하는 Disposable이 DisposeBag에 추가되고 DisposeBag이 해지되는 시점에 같이 해지됨

bag = DisposeBag() // 이전에 있던 DisposeBag 해지

// 1씩 증가하는 정수를 1초간격으로 방출하는 Observable
// 무한정 방출하기 때문에 방출을 중단시킬 수단이 필요 -> Dispose 메소드
let subscription2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe { element in
        print("Next", element)
    } onError: { error in
        print("Error", error)
    } onCompleted: {
        print("Completed")
    } onDisposed: {
        print("Disposed")
    }

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose()
    // :- dispose 메소드를 호출하면 모든 리소스가 해지되므로 더이상 이벤트 전달 X, completed 이벤트가 전달되지 않으므로 가능한 dispose메소드를 호출하는 것을 피해야함
}
