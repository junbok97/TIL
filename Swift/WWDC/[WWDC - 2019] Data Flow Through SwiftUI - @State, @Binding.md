




# UIKit에서 Data Flow

Swift UI가 나오기전 UIKit에서의 Data Flow는 보통 아래와 같았음

<img width="1000" alt="1" src="https://github.com/user-attachments/assets/001d8e81-96f7-4755-91cc-bc8be03eed51">

하나의 VC(PlayerViewController)에 하위 View(PlayerView, PlayButton)들이 있고 

VC의 Model에서 하위 View들에게 값을 전달해주는게 일반적이었는데 여기서 동기화의 문제가 발생 

PlayButton과 PlayerViewController의 isPlaying의 값이 동일해야 함 

혹은 다른 다양한 View에서 같은 속성(isPlaying)을 사용한다면 같은 속성을 사용하는 View들의 isPlaying 값이 동일해야 함 

즉 중복된 데이터들이 생기게 되고 어떤값이 진짜인지 알 수 없게 됨 

그래서 이 문제들을 해결하기위해 다양한 아키텍쳐 및 디자인 패턴들이 등장하였고 

결과적으로 View와 Model을 분리하고 Model을 한곳에서만 관리하여 View간의 동기화 문제를 해결하고자 하였음 

# SwiftUI에서 DataFlow
그래서 SwiftUI에선 새로운 Data Flow Tool들을 제공

SwiftUI는 UIKit과 다르게 VC가 없음 크게 뷰와 뷰의 상태정보만이 존재하는데

**SwiftUI에선 뷰의 상태 프로퍼티를 보관하는 장소가 따로 있음** 

**SwiftUI는 `@State`로 선언된 프로퍼티의 저장소를 관리** 

<img width="1000" alt="2" src="https://github.com/user-attachments/assets/da99e024-f7f8-49a6-aa40-a5a44c282844">


```swift
struct PlayerView: View {
    var isPlaying: Bool
    
    var body: some View {
          PlayerButton(isPlaying: isPlaying)
    }
}

struct PlayerButton: View {
    var isPlaying: Bool
}
```

PlayerView와 PlayerButton 둘 다 isPlaying이라는 프로퍼티가 필요해서 생기는 문제
- 기존까지의 방식으론 isPlaying 프로퍼티는 두 View에 존재하는 문제
- PlayerView의 isPlaying과 PlayerButton의 isPlaying 값을 동일하게 맞춰주려면 개발자가 별도의 로직을 구현
- SwiftUI는 View들이 struct이기 때문에 내부에서 isPlaying의 값을 바꿔주려면 Mutating 키워드를 붙혀야하는 문제

이때 사용하는것이 바로 `@State`


![3](https://github.com/user-attachments/assets/e184951e-ce01-4d40-9cfc-895ee0d0a395)


PlayerView의 isPlaying 프로퍼티 앞에 `@State` 키워드를 붙이는 순간 isPlaying 
프로퍼티는 **Single Source of Truth**이 되어 SwiftUI에서 관리

> Use state as the **single source of truth** for a given value stored in a view hierarchy.

![4](https://github.com/user-attachments/assets/6ad64d5e-a937-445d-9985-3fbc4c429a8b)


**Single Source of Truth**가 된 프로퍼티를 다른곳에서도 사용할 수 있게 해주는것이 `@Binding`

`@Binding`을 통해 `@State`로 **Single Source of Truth**가 된 프로퍼티 원본에 접근 가능

State 키워드가 붙은 프로퍼티의 prefix에 $를 추가하여 Binding

```swift
struct PlayerView: View {
    @State private var isPlaying: Bool
    
    var body: some View {
         PlayerButton(isPlaying: $isPlaying)
    }
}

struct PlayerButton: View {
    @Binding var isPlaying: Bool
}
```

SwiftUI는 상태프로퍼티의 값이 변경 되면 상태프로퍼티에 맞게 View가 업데이트가 되어야 한다는것을 알 수 있고

SwiftUI는 상태프로퍼티가 포함된 View 계층구조의 일부 View들을 업데이트

![5](https://github.com/user-attachments/assets/b1ffc8ab-558a-457d-b43f-ab852729c757)


# @State
<img width="1012" alt="6" src="https://github.com/user-attachments/assets/c9605b8a-cfdb-4fae-b206-afd5c3f8fce0">

SwiftUI에서 관리하는 값을 읽고 쓸 수 있는 property wrapper type

@State에 private 키워드를 붙이는것을 권장하고 있는데 외부에서 State 프로퍼티에 접근하지 못하게 해야

모든 스레드에서 State 프로퍼티의 값을 안전하게 변경할 수 있음

SwiftUI는 상태프로퍼티의 값이 변경 되면 상태프로퍼티에 맞게 View가 업데이트가 되어야 한다는것을 알 수 있고

SwiftUI는
 상태프로퍼티가 포함된 View 계층구조의 일부 View들을 업데이트

```swift
struct PlayerView: View {
    @State private var isPlaying: Bool
}
```

<img width="992" alt="7" src="https://github.com/user-attachments/assets/25080f7a-0256-444a-9009-7ce1ac9eb35a"> <br>
<img width="1002" alt="8" src="https://github.com/user-attachments/assets/1506f341-b2c2-47b7-9565-1bfaed8e6831"> <br>
<img width="976" alt="9" src="https://github.com/user-attachments/assets/2b1c0ada-9b6b-4645-939d-d39f6cba5b6b"> <br>

# @Binding
<img width="990" alt="10" src="https://github.com/user-attachments/assets/c88dcfbb-7346-4ee4-a62d-2803c624f1c2">

**Single Source of Truth(State Property)** 가 소유한 값을 읽고 쓸 수 있게 해주는 프로퍼티 랩퍼

State는 View내부에서 선언하는것과 달리 Binding은 상위 View로부터 전달받아서 사용

생성자를 통해 상위 View의 State 값을 주입받아야 하고 주입받을 상태프로퍼티의 이름에 prefix로 $표시를 붙혀 Binding

```swift
struct PlayerView: View {
    @State private var isPlaying: Bool
    
    var body: some View {
         PlayerButton(isPlaying: $isPlaying)
    }
}

struct PlayerButton: View {
    @Binding var isPlaying: Bool
}
```


<img width="977" alt="11" src="https://github.com/user-attachments/assets/48d28724-1129-499b-834f-966947bb2177">
<img width="991" alt="12" src="https://github.com/user-attachments/assets/edd263ee-80b7-483c-95b3-333121ffb9e0">

# 요약

- SwiftUI는 View와 View의 State관리가 중요
- SwiftUI는 `@State` 를 통해 **Single Source of Truth**를 나타낼수 있음
- SwiftUI는 `@State` 로 선언된 상태 프로퍼티의 저장소를 관리
- `@Binding` 을 통해 **Single Source of Truth(State Property)**에 접근 가능
- `@Binding` 을 할때는 `@State` 로 선언된 상태 프로퍼티의 이름에 prefix로 $표시를 추가해 사용
- SwiftUI는 **State프로퍼티**가 변하면 **State프로퍼티**가 포함된 View 계층구조의 일부 View들을 업데이트

# 참고
- [Data Flow Through SwiftUI - WWDC19 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/226/)
- [Data Essentials in SwiftUI - WWDC20 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10040/)
- [Introduction to SwiftUI - WWDC20 - Videos - Apple Developer](https://developer.apple.com/wwdc20/10119)
- [Demystify SwiftUI - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10022)
- [State | Apple Developer Documentation](https://developer.apple.com/documentation/swiftui/state)
- [Binding | Apple Developer Documentation](https://developer.apple.com/documentation/swiftui/binding)
- [Managing user interface state | Apple Developer Documentation](https://developer.apple.com/documentation/swiftui/managing-user-interface-state)
- [[iOS / SwiftUI] 사용자 인터페이스 상태 관리하기](https://velog.io/@niro/iOS-SwiftUI-View-State)
- [[WWDC19] Data Flow Through SwiftUI](https://velog.io/@marisol/WWDC19-Data-Flow-Through-SwiftUI)
- [[Swift] @State, @Binding, @Published 대해 알아보기(Property Wrapper 1편)](https://siwon-code.tistory.com/73)