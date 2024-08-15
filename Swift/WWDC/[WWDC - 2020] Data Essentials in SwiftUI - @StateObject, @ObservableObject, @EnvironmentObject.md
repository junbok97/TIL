# [WWDC - 2019] Data Flow Through SwiftUI - @State, @Binding 요약

- SwiftUI는 View와 View의 State관리가 중요
- SwiftUI는 `@State` 를 통해 **Single Source of Truth(SOT)** 를 나타낼수 있음
- SwiftUI는 `@State` 로 선언된 상태 프로퍼티의 저장소를 관리
- `@Binding` 을 통해 **Single Source of Truth(SOT)** 에 접근 가능
- `@Binding` 을 할때는 @State 로 선언된 상태 프로퍼티의 이름에 prefix로 $표시를 추가해 사용
- SwiftUI는 **State프로퍼티**가 변하면 **State프로퍼티** 가 포함된 View 계층구조의 일부 View들을 업데이트

# SwiftUI가 가장 중요하게 생각하는 것

- **Single Source of Truth(SOT)** 에 의한 상태(State) 관리
- UIKit에서는 데이터가 여기저기서 주고 받아지고, 그렇게 받아진 데이터를 여기저기서 수정. 결국에는 어떤게 진짜인지 헷갈리고 복사된 데이터 값들이 다 다르다 보니 버그에 취약해지기 때문에 개발자가 신경써야할 게 많았음. SwiftUI에선 그런 고민들을 시스템에서 다 처리해주자 !

# State, Binding은 Value Type을 위한 프로퍼티 래퍼

- 지난 글을 통해 배운 `@State`, `@Binding` 이 두가지의 프로퍼티 래퍼는 `Value Type`을 위한 것
- `struct`, `enum`, `Int`, `Bool` 등

# 그렇다면 Reference Type의 프로퍼티 래퍼는 ??

- `@StateObject`, `@ObservedObject`, `@EnvironmentObject`
- `@EnvironmentObject` 는 후반부에서 계속
- Single Source Of Truth
    - Value : `@State`
    - Reference : `@StateObject`
- Reference of SOT
    - Value : `@Binding`
    - Reference : `@ObservedObject`

# `protocol ObservableObject`

<img width="465" alt="1" src="https://github.com/user-attachments/assets/0675ed14-b3b4-4e93-b963-d3c5ce4910e8"> <br>
<img width="312" alt="2" src="https://github.com/user-attachments/assets/692dfe65-179f-495c-8f46-1a9be109cec2"> <br>
<img width="780" alt="3" src="https://github.com/user-attachments/assets/58e514e7-705c-4e32-95ea-c55af8759bdc"> <br>


- 프로퍼티 래퍼 `@StateObject`, `@ObservedObject` 를 사용하려면 class에선 `protocol ObservableObject` 을 채택해주어야 함
- `protocol ObservableObject` 은 `AnyObject` 를 채택 중 즉 class Type만 사용가능하다
- class에 `ObservableObject` 을 채택하고 class 내에서 관찰할 프로퍼티에 `@Published` 를 사용

<img width="392" alt="4" src="https://github.com/user-attachments/assets/6703df5e-8a5e-4a11-ac5e-99021130bab2">

- `@Published` 프로퍼티에서 변화가 생기면 값을 방출하여 SwiftUI가 뷰를 다시 그림
    - 값을 어디로 방출?
    - `protocol ObservableObject` 의 `objectWillCahnge`로

```swift
class ReadingListStore: ObservableObject {
    @Published var listName: String = "Book List"
}
```

# `@ObservedObject`

<img width="479" alt="5" src="https://github.com/user-attachments/assets/99dec74f-7604-4075-a5c0-abb183896004">


- `ObservableObject` class 를 관찰하려는 View에서 `@observedobject` 를 붙혀 사용
- `@observedobject` 는 뷰 내부에서 직접 초기화가 가능
- 하지만 `@observedobject` 는 인스턴스를 소유하고 있지 않고 있기 때문에 문제가 발생
    
<img width="753" alt="6" src="https://github.com/user-attachments/assets/db45881f-e5f1-4ba5-a92d-5dbdbaaa6b33">

    
- ReadingListViewer의 body가 호출될때마다 ReadingList() 로 인해  ReadingList.store의 Repeated heap allocation 문제 발생
- 이때 사용하는것이 `@StateObject`
- [StateObject lets SwiftUI instantiate your ObservableObjects at the right time,](https://developer.apple.com/videos/play/wwdc2020/10040/?time=1606)
[so you don't incur unnecessary heap allocations, and you don't lose data.](https://developer.apple.com/videos/play/wwdc2020/10040/?time=1610)
    
<img width="763" alt="7" src="https://github.com/user-attachments/assets/aeaadd3a-b92f-4072-a925-558a3db50099">



# `@StateObject`
<img width="437" alt="8" src="https://github.com/user-attachments/assets/b1463548-e4e8-4a6d-82c9-717149ae8994">

```swift
struct ReadingList: View {
    @StateObject private var store = ReadingListStore()
    
    var body: some View {
        ReadingItem(store: store)
    }
}

struct ReadingItem: View {
    @ObservedObject var store: ReadingListStore
    
    var body: some View {
    }
}
```

# 그림으로 쉽게 이해하기
<img width="346" alt="9" src="https://github.com/user-attachments/assets/7b6f3408-603a-430a-b8af-d9361f154cb4"> <br>
<img width="556" alt="10" src="https://github.com/user-attachments/assets/48bcdee8-a15f-4c82-aee5-b53d05fe39aa"> <br>
<img width="745" alt="11" src="https://github.com/user-attachments/assets/dd276b9e-35bb-4ae5-b763-c4e885d055cb"> <br>
<img width="501" alt="12" src="https://github.com/user-attachments/assets/68229f6b-f47f-4ced-a88c-0c67d667611c"> <br>

[Note that the lifetime of a view](https://developer.apple.com/videos/play/wwdc2020/10040/?time=1406)
[is separate from the lifetime of a struct that defines it.](https://developer.apple.com/videos/play/wwdc2020/10040/?time=1408)

# `@EnvironmentObject` 는 왜 생겨났나

- `ObservableObject` 가 필요한 곳이 멀리 떨어져 있다면 ?
<img width="969" alt="13" src="https://github.com/user-attachments/assets/420ebfb8-4025-4c53-91f6-cd60a7f12b5c">



- `ObservableObject` 가 필요하지 않은 뷰임에도 하위 뷰로 전달하기 위해서 추가해주어야 함
<img width="1118" alt="14" src="https://github.com/user-attachments/assets/7039b161-4af3-4d27-b2b0-4810a5fbcca5">



```swift
class MyObservableObject: ObservableObject { }

struct View1: View {
    @StateObject var myObservableObject = MyObservableObject()
    
    var body: some View {
        View2(myObservableObject: myObservableObject)
    }
}

struct View2: View {
    @ObservedObject var myObservableObject: MyObservableObject
    
    var body: some View {
        View3(myObservableObject: myObservableObject)
    }
}

struct View3: View {
    @ObservedObject var myObservableObject: MyObservableObject
    
    var body: some View {
        View4(myObservableObject: myObservableObject)
    }
}

// myObservableObject 필요한 곳
struct View4: View {
    @ObservedObject var myObservableObject: MyObservableObject
    
    var body: some View {
        myObservableObject
    }
}
```

- 이럴때 사용하는 것이 `@EnvironmentObject`
    
<img width="1609" alt="15" src="https://github.com/user-attachments/assets/f5e75398-6f04-4a6c-817d-3e72c11774b5">

    
- 뷰에 `environmentObject` 로 등록하면 계층구조에 상관없이 접근 가능
- `@EnvironmentObject` 를 사용하여 `ObservableObject` 가 필요한 뷰에서 접근

```swift
class MyObservableObject: ObservableObject {}

struct MyContentView: View {
    var body: some View {
        View1()
            .environmentObject(MyObservableObject())
    }
}

struct View1: View {
    
    var body: some View {
        View2()
    }
}

struct View2: View {
    
    var body: some View {
        View3()
    }
}

struct View3: View {
    var body: some View {
        View4()
    }
}

struct View4: View {
    @EnvironmentObject var myObservableObject: MyObservableObject
    
    var body: some View {
        myObservableObject
    }
}
```

[Luckily, we have a solution for this problem with EnvironmentObject.](https://developer.apple.com/videos/play/wwdc2020/10040/?time=1288)[EnvironmentObject is both a view modifier and a property wrapper.](https://developer.apple.com/videos/play/wwdc2020/10040/?time=1292)

# 참고

https://developer.apple.com/videos/play/wwdc2020/10040/

https://developer.apple.com/documentation/Combine/ObservableObject

https://developer.apple.com/documentation/combine/published

https://developer.apple.com/documentation/swiftui/observedobject

https://developer.apple.com/documentation/swiftui/stateobject

https://developer.apple.com/documentation/Combine/ObservableObject

https://developer.apple.com/documentation/swiftui/environmentobject