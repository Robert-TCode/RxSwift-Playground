import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import RxCocoa

var names = BehaviorRelay(value: ["Peter"])

names.asObservable()
    .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    .filter { value in
        value.count > 1
    }
    .map { value in
        value.joined(separator: ", ")
    }
    .debug()
    .subscribe(onNext: { value in
        print(value)
    })

names.accept(["Peter", "Jhon"])

names.accept(["Jessica", "Jhon"])

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
    names.accept(["Jessica", "Alice"])
}

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
    names.accept(["Jessica"])
}

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
    names.accept(["Admin"])
}
