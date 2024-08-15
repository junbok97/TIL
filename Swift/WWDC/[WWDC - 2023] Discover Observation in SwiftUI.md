# What is Observation ?

<img width="794" alt="1" src="https://github.com/user-attachments/assets/b344c0cf-494c-42e9-a6eb-5b97c8bf439a">

**기본 데이터가 변경될 때 프레젠테이션을 업데이트하는 반응형 앱을 만듭니다.**

`@Obserable` 은 normal type의 property를 observable type으로 마킹하여 UI가 data의 변화에 대응할 수 있게 해주는 매크로

`@Obserable` 은 Swift 컴파일러에게 명령을 내려서 코드를 확장형 Observable type으로 바꿔 SwiftUI가 뷰를 동작하게 만듬

reference type, value type을 모두 지원

`@Published` `@State` `@Binding` `@ObservedObject` 등 다른 프로퍼티 래퍼가 없어도 작동함

각 property마다 `@Published` `@State` `@Binding` `@ObservedObject` 등을 붙인것을 data model에 붙인다고 이해하면 됨

```swift
// Before
class FoodTruckModel {    
    var orders: [Order] = []
    var donuts = Donut.all
}

// After
@Observable class FoodTruckModel {    
    var orders: [Order] = []
    var donuts = Donut.all
}
```

## Examples

SwiftUI는 body가 실행될 때 Observable 타입에서 사용된 property의 모든 접근을 추적함

이 추적 정보를 이용해 특정 인스턴스에서 property의 다음변화가 언제 일어날지를 예측

<img width="1512" alt="2" src="https://github.com/user-attachments/assets/170358f8-767a-4f07-a03e-045b71f814b4">

DonutMenu의 body에서 model.donuts에 접근이 이루어져 SwiftUI가 donuts를 추적

도넛 추가 버튼을 클릭해 donuts가 변경되면 DonutMenu View가 무효화 되고 변경사항에 맞춰 UI가 업데이트 됨

orders가 변경되었을 때는 DonutMenu View가 무효화 되지 않음

view의 body에서 접근하지 않고 있어 SwiftUI가 추적하지 않는 property이기 때문

연산 프로퍼티에도 같은 규칙이 적용 됨 **프로퍼티가 변하면 UI는 업데이트**

```swift
@Observable class FoodTruckModel {    
  var orders: [Order] = []
  var donuts = Donut.all
  var orderCount: Int { orders.count }
}

struct DonutMenu: View {
  let model: FoodTruckModel
    
  var body: some View {
    List {
      Section("Donuts") {
        ForEach(model.donuts) { donut in
          Text(donut.name)
        }
        Button("Add new donut") {
          model.addDonut()
        }
      }
      Section("Orders") {
        LabeledContent("Count", value: "\(model.orderCount)")
      }
    }
  }
}
```

위의 코드에서 FoodTruckModel에 orderCount라는 연산 프로퍼티를 추가

view의 body에서 orderCount에 접근하여 orderCount를 추적 

orderCount는 orders에 접근했으므로 orders가 변경되면 view가 업데이트

## @Observable

- @Observable 매크로를 사용하면 타입이 확장되어 Observation을 지원
- SwiftUI는 프로퍼티의 접근을 추적, Observation에서 해당 프로퍼티가 언제 변할지 관찰 가능
- 추적이 가능해지면 프로퍼티가 변할때 UI는 view의 body를 재계산 하면 끝

<img width="1512" alt="3" src="https://github.com/user-attachments/assets/d5691a51-ec9f-488f-9cfa-597e208c13c2">

# SwiftUI property wrappers

SwiftUI의 핵심 프로퍼티 래퍼 3가지는 State, Environment, Bindable

## @Observable에서 SwiftUI의 프로퍼티 래퍼가 필요한 경우

### @State

model안에 view 전용 상태를 저장해야할 때 사용

<img width="1512" alt="4" src="https://github.com/user-attachments/assets/7796f836-d410-4443-b975-16607365d978">

donutToAdd는 소속된 donutListView의 view의 수명 동안만 관리 

### @Environment

Environment는 각 값을 어디에서든 접근 가능하게 만들어 줌 → Global로 만들어 준다

observable 타입이 Environment와 잘 맞는데 observable은 접근을 추적하여 업데이트 하기  때문에 여러곳에서 공유하는 Environment와 잘 맞음

<img width="1512" alt="5" src="https://github.com/user-attachments/assets/4f07cf03-ab3d-4779-8861-39bc4ca22106">

FoodTruckMenuView의 body를 불러올 때 Observable 타입의 Account의 userName에 접근하게 됨

userName이 변경되면 FoodTruckMenuView의 body도 업데이트

### @Bindable

가장 최근에 생긴 프로퍼티 래퍼 굉장히 가볍다

해당 타입으로부터 바인딩이 생성되게 하는 기능만 있음 

래핑된 Bindable 프로퍼티에서 바인딩을 만드는 방법은 굉장히 쉬운데 $구문을 사용해 프로퍼티에 바인딩을 만들면 됨 

<img width="1512" alt="6" src="https://github.com/user-attachments/assets/e9b14ddd-5d54-47b3-9f19-b0fd3fb5a75b">

모델이 view로 있어야 한다면 → `@State` 

모델이 전역(Global)으로 있어야 한다면 → `@Environment`

모델에 바인딩만 필요하다면 → `@Bindable`

셋 다 아니라면 `var`

<img width="1512" alt="7" src="https://github.com/user-attachments/assets/2dc1cf25-9046-4a05-9c61-f0dfecc87971">

# Advanced uses

SwiftUI는 프로퍼티 접근을 인스턴스마다 추적하기 때문에 Observable 모델이 포함된 어떤 타입도 사용될 수 있음

## Example
<img width="1512" alt="8" src="https://github.com/user-attachments/assets/4aa1d61e-18fe-4ce2-b8c3-c4d2608999d5">


DonutList는 donuts 배열을 가지고 있는데 이 배열은 모두 `@Observable` 

Donut의 name이 하나라도 변경되면 SwiftUI는  언제 뷰를 무효화할지를 파악하기 위해  해당 프로퍼티에 일어난 접근을 포착하여 추적함

**Observable의 기본 규칙은 사용중인 프로퍼티가 변경되면 뷰도 업데이트 된다는 것**

단 예외도 존재하는데 연산 프로퍼티에 사용된 저장 프로퍼티가 없다면 Observation에서 사용되기 전에 2단계를 더 거쳐가게  됨

이는 관찰 대상인 프로퍼티가 observable 타입에 저장된 구성에 의해 변경되지 않았을 때만 필요한 조치임

이 경우엔 프로퍼티에 접근과 변경이 언제 이루어졌는지 Observation에 전달해주기만 하면 됨

### Manual Observation
<img width="1512" alt="9" src="https://github.com/user-attachments/assets/417114cd-b232-4423-8721-c72ed92ce580">

access point를 수동으로 고쳐서 someNonObservableLocation의 name을 저장하게 해줌

이러한 직접 구현이 필요한 경우는 드문데 왜냐하면 보통 이런 모델의 프로퍼티는 다른 저장 프로퍼티처럼 구성되기 때문

하지만 고급 기능이 필요한 경우엔 직접 구현하면 됨 

## Computed properties (연산 프로퍼티)

- SwiftUI는 구성의 변화를 바로 인식하는데 프로퍼티 접근을 바탕으로 Observable 타입을 추적하기 때문
- 연산 프로퍼티에 다른 저장 프로퍼티를 사용하여도 Observation이 잘 작동하게 됨
- 하지만 드물게 Observation이 작동하지 않으면 직접 구현하여 프로퍼티의 접근과 변경이 언제 일어나는지만 알려주면 됨

<img width="500" alt="10" src="https://github.com/user-attachments/assets/aa179151-a688-4d49-94ed-1e33ce8216b4">


# @ObservableObject

## @ObservableObject → @Observable

`@ObservableObject` 에서 `@Observable` 로 넘어가려면 대부분의 어노테이션을 삭제하거나 

`@State` `@Environment` `@Bindable` 이 세가지로 단순화하면 됨

```swift
// Before
class FoodTruckModel: ObservableObject {
    @Published var truck = Truck()
    
    @Published var orders: [Order] = []
    @Published var donuts = Donut.all
    
    var dailyOrderSummaries: [City.ID: [OrderSummary]] = [:]
    var monthlyOrderSummaries: [City.ID: [OrderSummary]] = [:]
    ...
}

struct AccountView: View {
    @ObservableObject var model: FoodTruckModel
    
    @EnvironmentObject private var accountStore: AccountStore
    @Environment(\.authorizationController) private var authorizationController
    
    @State private var isSingUpSheetPresented = false
    @State private var isSingOutSheetPresented = false
    ...
}

// After
@Observable
class FoodTruckModel {
    var truck = Truck()
    
    var orders: [Order] = []
    var donuts = Donut.all
    
    var dailyOrderSummaries: [City.ID: [OrderSummary]] = [:]
    var monthlyOrderSummaries: [City.ID: [OrderSummary]] = [:]
    ...
}

struct AccountView: View {
    var model: FoodTruckModel
    
    @Environment(AccountStore.self) private var accountStore: AccountStore
    @Environment(AuthorizationController.self) private var authorizationController
    
    @State private var isSingUpSheetPresented = false
    @State private var isSingOutSheetPresented = false
    ...
}
```

## @ObservableObject와 @Observable 차이점

### 코드가 간결해짐

observable에서는 대부분의 어노테이션이 필요가 없어지기 때문

### 옵셔널 가능

observable은 옵셔널 가능 

observableObject 은 옵셔널 불가능

```swift
// ObservableObject
class FoodTruckModel: ObservableObject {
    ...
}

struct AccountView: View {
    @ObservableObject var model: FoodTruckModel? // 컴파일 에러
}

// Observable
@Observable
class FoodTruckModel {
    ...
}

struct AccountView: View {
    var model: FoodTruckModel? // 가능
}
```

### 성능 향상

ObservableObject 에서는 published property 가 변하면 뷰의 body에서 해당 프로퍼티를 읽고 있지 않아도 다시 그려짐

```swift
final class Food: ObservableObject {

    let name = "Food Name"
    @Published var isAvailable = true
    
    var cancellable: Cancellable?

    func connectTimer() {
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.isAvailable.toggle()
            }
    }
}

struct FoodMenuView: View {
    @ObservedObject var food: Food
    
    var body: some View {
        Text(food.name)
            .background(.random)
            .onAppear {
                food.connectTimer()
            }
    }
}
```

FoodMenuView의 body에서 isAvailable를 접근하고 있지 않음에도 isAvailable가 변경되면 뷰가 계속 업데이트 됨

Observable은 뷰의 body에서 프로퍼티를 읽어야 업데이트 되기 때문에 불필요한 업데이트가 일어나지 않아 성능이 향상

```swift
@Observable
final class Food: ObservableObject {

    let name = "Food Name"
    var isAvailable = true
    
    var cancellable: Cancellable?

    func connectTimer() {
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.isAvailable.toggle()
            }
    }
}

struct FoodMenuView: View {
    var food: Food
    
    var body: some View {
        Text(food.name)
            .background(.random)
            .onAppear {
                food.connectTimer()
            }
    }
}
```

FoodMenuView의 body에서 isAvailable를 접근하고 있지 않기 때문에 isAvailable가 변경되어도 뷰가 업데이트 되지 않음

# 참고

https://developer.apple.com/videos/play/wwdc2023/10149/

https://developer.apple.com/videos/play/wwdc2023/10166

https://developer.apple.com/videos/play/wwdc2023/10167

https://developer.apple.com/documentation/observation

https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app

https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro

https://eunjin3786.tistory.com/580

https://eunjin3786.tistory.com/582