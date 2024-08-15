- [[WWDC - 2021] Demystify SwiftUI ‐ 1 - Identity](https://github.com/junbok97/TIL/blob/main/Swift/WWDC/%5BWWDC%20-%202021%5D%20Demystify%20SwiftUI%20%E2%80%90%201%20-%20Identity.md)
- [[WWDC - 2021] Demystify SwiftUI ‐ 2 - Lifetime](https://github.com/junbok97/TIL/blob/main/Swift/WWDC/%5BWWDC%20-%202021%5D%20Demystify%20SwiftUI%20%E2%80%90%202%20-%20Lifetime.md)
- [[WWDC - 2021] Demystify SwiftUI ‐ 3 - Dependency](https://github.com/junbok97/TIL/blob/main/Swift/WWDC/%5BWWDC%20-%202021%5D%20Demystify%20SwiftUI%20%E2%80%90%203%20-%20Dependency.md)


<img width="839" alt="1" src="https://github.com/user-attachments/assets/4ae2fcad-ad69-49fa-9b87-99e6c9c4b8bb">

# 🤔 SwiftUI는 우리의 코드에서 어떤걸 볼까 ?

### **Identity**

- SwiftUI가 여러번의 업데이트 동안 **요소(element)**가 동일한것인지 다른것인지 **인식(recognize)**하는 방법

### **Lifetime**

- SwiftUI가 뷰와 데이터의 **존재(existence)**를 시간에 따라 추적하는 방법

### **Dependency**

- SwiftUI가 인터페이스를 업데이트해야하는 **시기(when)**와 이유**(why)**를 이해하는 방법

이 세 가지 개념을 통해 SwiftUI는 **변경해야할 사항(what needs to change)**, **시기(when)**, **방법(how)** 을 **결정**할 수 있어 결과적으로 동적인 사용자 인터페이스가 화면에 표시

# **Identity**

<img width="1512" alt="2" src="https://github.com/user-attachments/assets/8e482aa8-9269-4173-8360-50f62423d1d6">

이 2개의 강아지 발바닥 뷰는 서로 **다른 뷰(Different Views)** ? 

아니면 단지 위치와 배경색만 바뀐 하나의 **뷰(Same View)** ? 

이러한 구별은 인터페이스가 한 State에서 다른 State로 전환되는 방식이 달라지기 때문에 매우 중요

만약 서로 **다른 뷰(Different Views)**라면? fade in/out 과 같은 **독립적인 방식으로 전환**

하지만 사실은 서로 **같은 뷰(Same View)**라면 ? 동일한 뷰이기 때문에 현위치에서 다른 위치로 화면을 가로질러 이동하는 방식으로 전환

**SwiftUI는 View Identity에 따라 한 State에서 다른 State로 인터페이스가 전환되는 방식이 달라지게 되는데
이것이 View Identity의 핵심(key concept)** 

<img width="1512" alt="3" src="https://github.com/user-attachments/assets/03992c28-ab2a-4360-bdc7-3091a9324b6a">
<img width="1512" alt="4" src="https://github.com/user-attachments/assets/0b789aa6-fc44-4ab9-b6a0-a519250af76e">

# Type of Identity

- **Explicit Identity**
    - 사용자 정의 또는 데이터 기반 identity를 사용
- **Structural Identity**
    - view hierarchy 에서 타입 및 위치에 따라 뷰를 구분

# **Explicit Identity**

**Explicit Identity** 의 한가지 예시는 `UIKit`과 `AppKit`에서 사용중인 **Pointer identity**

`UIView` 와 `NSView` 는 `Reference Type` 인 `Class` 이기 때문에 각각 메모리에 할당에 대한 고유한 포인터가 있음

포인터를 사용하여 개별 뷰를 참조할 수 있으며 여려 뷰가 동일한 포인터를 공유하는 경우 실제로 같은 뷰임을 보장

<img width="1512" alt="5" src="https://github.com/user-attachments/assets/ff2eaf57-0fa7-4f5d-9ad5-ede9aaa6d8a5">

하지만 `SwiftUI` 의 `View` 는`Value Type` 인 `Struct` 이기 때문에 고유한 포인터가 없음

`SwiftUI` 가 `UIKit` 과 동작하는 방식이 다른 이유

**SwiftUI에서 View 를 Value Type으로 표현하는 이유**

- Not allocated, no pointers
- Efficient memory representation
- Supports small, single-purpose components

<img width="1512" alt="6" src="https://github.com/user-attachments/assets/5bb7cd2e-c7cb-4706-8de0-ae541a79a354">

대신 SwiftUI는 다른 형태의 **Explicit Identity** 를 사용 

아래의 예시에서 사용된 `dogTagID` 매개변수는 Explicit Identity의 형태 중 하나로 List에서 View를 명시적으로 식별하는데 사용 

List가 변경되면 해당 `ID`를 사용하여 무엇이 바뀐지를 파악하고 올바른 애니메이션을 생성

<img width="1512" alt="7" src="https://github.com/user-attachments/assets/a4941f47-9bc0-4ae4-b658-2ee87a9032d7">

`HeaderView`의 **`.id(_ :)` modifier**을 사용해서 **custom identifier** 설정도 가능

여기서 주목해야 할 것은 모든 뷰를 명시적으로 식별할 필요가 없고 `HeaderView` 처럼 다른곳에서 참조해야 하는 뷰만 식별하면 된다는 것

<img width="1512" alt="8" src="https://github.com/user-attachments/assets/75bb7e8a-444a-4045-9d36-b321d4e05e71">

다른곳에서 참조해야하는 `HeaderView` 는 **Explicit Identity가 필요**

<img width="1512" alt="9" src="https://github.com/user-attachments/assets/da7b70a9-b1e0-487c-955e-c0b86a795883">

다른곳에서 참조할 필요가 없는 `ScrollViewReader` `ScrollView` `Text` `Button` 은 **Explicit Identity가 필요 없음**


<img width="1512" alt="10" src="https://github.com/user-attachments/assets/4fc4d712-caa2-40ec-ab93-fa23cd14c25c">

명시적이지 않았다고 해서 그것이 뷰의 identity가 없다는 것을 의미하는 것은 아님

**모든 뷰는 explicit identity** 아니더라도 **identity가 존재**

여기서 등장하는 것이 바로 **Structural Identity** 

SwiftUI는 view hierarchy를 사용하여 뷰에 대한 암시적 ID(**implicit Identity**)를 생성하기 때문에 사용자가 아이디를 생성할 필요가 없음

<img width="1512" alt="11" src="https://github.com/user-attachments/assets/4fe8c209-8b2e-4d30-8a13-48b286fe1409">

# **Structural Identity**

**Structural Identity**는 **상대적인 위치에 따라 결정**

SwiftUI는 API 전반에서 **Structural Identity** 를 사용하는데 대표적인 예는 View 코드 내의 **if문 처럼 조건부 로직**을 사용하는 경우

아래 예시 처럼 조건문의 구조는 각 뷰를 식별하는 명확한 방법을 제공

`True` 일 때는 항상 `AdoptionDirectory`가  `False` 일 때는 항상 `DogList`가 표시

즉 유사하게 보이더라도 위치에 따라 어느 뷰인지 판별 가능

<img width="1512" alt="12" src="https://github.com/user-attachments/assets/072d84a2-5fc5-44ba-b541-ef505d8c60aa">

하지만 이 방법은 view들이 자리를 변경하지 않고(swap) 계속해서 같은 자리에 있음을(stay) SwiftUI가 정적으로 보장 받을 수 있을 때만 작동

SwiftUI는 뷰 계층 구조(view hierarchy)의 type 구조를 살펴봄으로서 이를 수행

SwiftUI가 뷰를 볼때는 위 코드는 참/거짓 content 정보를 가지는 하나의 `generic type` 인 `_ConditionalContent<TrueContent, FalseContent>` 로 변환

이 변환은 Swift의 result Builder type인 `ViewBuilder` 에 의해 수행

`view protocol` 에서는 `body property` 를 암시적으로 `ViewBuilder` 에 래핑하기 때문에 우리가 따로 명시하지 않아도 됨

<img width="1473" alt="13" src="https://github.com/user-attachments/assets/08384e4e-2d57-4838-82b4-fb8f4cd3183b">
<img width="1512" alt="14" src="https://github.com/user-attachments/assets/b0ed35d6-1f46-4190-bed2-b19d441e06bd">
<img width="1512" alt="15" src="https://github.com/user-attachments/assets/5e9c1969-6393-4d52-968c-5e572918052f">

`generic type` 인 `_ConditionalContent<TrueContent, FalseContent>` 를 사용하여 SwiftUI는 `true`일때는 항상 `AdoptionDirectory` 가 `false`일 때는 항상 `DogList` 라는 것을 보장

안정적으로 암시적 identity를 할당

이로 인해서 SwfitUI는 if문의 분기가 고유한 id를 가지는 다른 뷰를 나타내는 것을 이해하기 때문에 

if문일 때는 서로 다른 id를 가지는 다른 뷰(Different Views)이기 때문에 fade in/out 과 같은 독립적인 방식으로 전환

<img width="1512" alt="16" src="https://github.com/user-attachments/assets/76ede725-681b-4a76-8bb1-105cb3f7e49d">

동일한 뷰(Same View)일때는 일관된 ID로 단일 뷰를 수정하기 때문에 현위치에서 다른 위치로 화면을 가로질러 이동하는 방식으로 전환

<img width="1512" alt="17" src="https://github.com/user-attachments/assets/015ff12d-8b10-48ea-99ca-e806ae6720fc">

위의 두 방법 모두 작동하지만 SwiftUI는 일반적으로 두번째 방식인 단일ID를 유지하고 유연한 전환을 제공하는 방식을 권장 

 이는 뷰의 수명과 상태를 보존하는데 도움이 되기 때문

# Evil nemesis AnyView

### AnyView가 뷰의 구조에 미치는 영향

분기 마다 서로 다른 종류의 뷰를 return하기 때문에 함수의 return Type을 통일하기 위해 AnyView로 래핑

<img width="1512" alt="18" src="https://github.com/user-attachments/assets/0e9d48f5-f297-41b4-b501-0dc0b68ad063">

`AnyView`로 래핑되면 함수의 return Type을 `AnyView`로 간주하기 때문에 SwiftUI는 조건부 구조를 확인할 수 없게 됨

<img width="1512" alt="19" src="https://github.com/user-attachments/assets/aef0bd25-6181-460d-8c80-82e1237bd576">

`AnyView`가 “type-erasing wrapped type” 라 불리는 이유

`AnyView`는 generic signature에서 view의 type을 숨김

또한 코드의 가독성이 떨어지게 됨

`AnyView` 를 언래핑하게되면 컴파일 에러가 발생하는데 SwiftUI가 단일 return type을 요구하기 때문

<img width="1512" alt="20" src="https://github.com/user-attachments/assets/802783ba-04c3-4ca0-bf2b-2d04a53dbea1">

이러한 오류를 피할려고 하면 ?

`View protocol` 이 암시적으로 `ViewBuilder` 에 래핑하기 때문에 `body property` 가 특별하다는것을 기억하면 됨

Swift는 기본적으로 `help function` 을 `ViewBuilder` 로 추론하지 않지만 명시적으로 `ViewBuilder` 속성을 적용 가능

이를 통해 경고나 오류 없이 `AnyView` 언래핑 가능

<img width="1512" alt="21" src="https://github.com/user-attachments/assets/fd0de82c-e377-4247-a5c6-1dba3a69ac73">

type signature의 결과를 보면 `_ConditionalContent` 트리를 통해 SwiftUI에게 ID 제공

<img width="1512" alt="22" src="https://github.com/user-attachments/assets/506873c5-81b6-4798-a92d-f02465de5a49">

switch문을 사용하여 코드 가독성을 더욱 높일 수 있음

<img width="1512" alt="23" src="https://github.com/user-attachments/assets/1da7e6ff-d996-425b-937d-9d34ff098375">
<img width="844" alt="24" src="https://github.com/user-attachments/assets/8ba933b7-edce-430c-9e22-2244e3014895">


## AnyView 사용을 지양해야 하는 이유

- 코드 가독성 저하
- AnyView는 컴파일러에서 static type 정보를 숨기기 때문에 도움이 되는 에러나 경고 파악 불가
- 퍼포먼스 저하

AnyView 대신 generic 사용을 지향

# 참고

https://developer.apple.com/videos/play/wwdc2021/10022