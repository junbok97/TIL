- [[WWDC - 2021] Demystify SwiftUI ‐ 1 - Identity](https://github.com/junbok97/TIL/blob/main/Swift/WWDC/%5BWWDC%20-%202021%5D%20Demystify%20SwiftUI%20%E2%80%90%201%20-%20Identity.md)
- [[WWDC - 2021] Demystify SwiftUI ‐ 2 - Lifetime](https://github.com/junbok97/TIL/blob/main/Swift/WWDC/%5BWWDC%20-%202021%5D%20Demystify%20SwiftUI%20%E2%80%90%202%20-%20Lifetime.md)
- [[WWDC - 2021] Demystify SwiftUI ‐ 3 - Dependency](https://github.com/junbok97/TIL/blob/main/Swift/WWDC/%5BWWDC%20-%202021%5D%20Demystify%20SwiftUI%20%E2%80%90%203%20-%20Dependency.md)

# 🤔 SwiftUI는 우리의 코드에서 어떤걸 볼까 ?

### **Identity**

- SwiftUI가 여러번의 업데이트 동안 **요소(element)** 가 동일한것인지 다른것인지 **인식(recognize)** 하는 방법

### **Lifetime**

- SwiftUI가 뷰와 데이터의 **존재(existence)** 를 시간에 따라 추적하는 방법

### **Dependency**

- SwiftUI가 인터페이스를 업데이트해야하는 **시기(when)** 와 이유 **(why)** 를 이해하는 방법

이 세 가지 개념을 통해 SwiftUI는 **변경해야할 사항(what needs to change)**, **시기(when)**, **방법(how)** 을 **결정**할 수 있어 결과적으로 동적인 사용자 인터페이스가 화면에 표시

# How SwiftUI updates the UI ?

The goal is to give you a better mental model for how to structure SwiftUI code.

# **Dependency**

- dependency는 단순히 view에 대한 input일 뿐임
- dependency가 변경되면 view는 새로운 body를 생성해야 함
- body는 뷰 계층 구조를 생성하는 곳
- action은 뷰의 dependencies에 대한 변경의 trigger

<img width="1512" alt="1" src="https://github.com/user-attachments/assets/54ae8a7a-ed54-4866-8605-1fbb8ef9c688">


위 코드를 도식화하면 아래와 같음

<img width="1512" alt="2" src="https://github.com/user-attachments/assets/24a4b707-c7b5-4ef3-8442-74b9089c1655">

버튼을 탭하면 강아지에게 보상을 주는 액션이 전달됨

그 결과 강아지는 변화가 생김 

dependecy가  변화되었기 때문에 DogView는 새로운 body를 그려야 함

<img width="1512" alt="3" src="https://github.com/user-attachments/assets/c52a7504-0371-4b47-9e1d-16ea782095c7">

뷰 계층 구조에 초점을 맞춰 그래프를 조금 더 단순화 하여 확인해보면 

DogView에 dependecy를 추가해도 여전히 tree로 보임

<img width="1512" alt="4" src="https://github.com/user-attachments/assets/11756fef-8d40-4ca0-b1ac-2acacf08b08b">

DogView뿐 아니라 다른곳에서도 dependecy가 추가될 수 있음

SwiftUI는 자체 dependecy를 가질 수도 있음

<img width="1512" alt="5" src="https://github.com/user-attachments/assets/8f45c178-7507-4861-8647-0a944b229e6f">

또한 아래처럼 동일한 state나 data에 다수의 view가 의존할 수 도 있음 

<img width="1512" alt="6" src="https://github.com/user-attachments/assets/0a1b7f06-b506-4058-acad-c9e0d7e542fe">

아직까진 tree처럼 보이지만 선이 겹치는 것을 피하기 위해 재배치 해보면 실제론 tree가 아니라 greaph 임을 알 수 있음

이 구조를 **dependecy graph** 라고 부름 

이 구조는 SwiftUI가 새로운 body가 필요한 view만 효율적으로 업데이트 할 수 있도록 해주기 때문에 중요함

<img width="1512" alt="7" src="https://github.com/user-attachments/assets/e6070d8e-298a-4c05-8352-ecb2a1f61f1a">

가장 하단의 dependency를 예로 들면 이 dependency에 영향을 받는 view는 2개가 있음

dependency graph의 비밀은 dependency가 변경되면 dependency에 영향을 받는 뷰만 무효화

SwiftUI는 무효화된 각 view의 body를 호출하여 각 view에 대한 새로운 body value를 인스턴스 

이로 인해 무효화된 view와 연관된 더 많은 dependency가 변경될 수 있지만 **항상 그런 것은 아님**

SwiftUI에서 view는 value type이기 때문에 이를 효율 적으로 비교하여 view의 올바른 하위 집합만 업데이트

view의 value(struct)는 수명이 매우 짧아 값 비교에만 사용되지만 view 자체 수명은 이보다 더 김

<img width="1512" alt="8" src="https://github.com/user-attachments/assets/f1ce9c5a-fd03-415d-902a-fbd76f8976f6">
<img width="1512" alt="9" src="https://github.com/user-attachments/assets/525f998c-8f85-405c-9c72-2a1049ebb77d">
<img width="1920" alt="10" src="https://github.com/user-attachments/assets/2ef420b7-79c6-4a7c-a39b-856c8424d9f4">


### Identity is the backbone of the graph
- **identity는 dependecy graph의 핵심(backbone)**
- 모든 view는 **명시적(Explicit)** 또는 **구조적(Structural)** identity를 가지고 있음
- 이 identity를 통해 SwiftUI는 변경사항을 올바른 View에 전달하고 UI를 효율적으로 업데이트 할 수 있음

<img width="500" alt="11" src="https://github.com/user-attachments/assets/3ed40a44-03a1-4b48-85f7-d2755599e5fe">

### Kinds of dependencies
- `@Binding`
- `@Environmnet`
- `@State`
- `@StateObject`
- `@ObservedObject`
- `@EnvironmnetObject`

<img width="500" alt="12" src="https://github.com/user-attachments/assets/fb55a04f-c85a-4b90-9c97-09ac91dc8082">

# identity의 활용을 향상시키는 방법

# Explicit Identity 사용 시 고려사항

## Identifier의 안정성(stablilty)

뷰의 수명은 id의 지속시간이므로 identity의 안정성(stablilty)이 중요함 

안정성이 강한 identity를 갖게 되면 SwiftUI는 view에 대한 storage를 지속적으로 생성하거나 
dependency graph를 업데이트 하지 않아도 되기 때문에 성능(performance) 향상에 도움

또한 SwiftUI는 identity를 사용하여 persisted storage를 관리하기 때문에 state 손실 방지에도 도움

**하지만 안정성이 좋다고 해서 유일한 것은 아님**

<img width="500" alt="13" src="https://github.com/user-attachments/assets/92a93df2-68d3-45ef-bfbe-c187b9a89bee">

## Identifier의 고유성(uniqueness)

좋은 identity의 또 다른 조건은 **고유성(uniqueness)** 

즉, 각각의 identity는 단 하나의 뷰(single view)에만 매핑 되어야 함 (1:1 매치)

<img width="500" alt="14" src="https://github.com/user-attachments/assets/bdfdf12e-280f-4565-9af1-6f1bf05fe52f">

# Example of Explicit identity

<img width="1920" alt="15" src="https://github.com/user-attachments/assets/9ca87352-08f1-435e-a5c0-7c8fadc5568d">


이 코드에는 버그가 있는데 바로 id를 UUID()로 초기화 해주는 것임

데이터가 변경될때마다 새로운 id를 얻기 때문에 안정적이지 않음
<img width="1920" alt="16" src="https://github.com/user-attachments/assets/be24b048-e122-4796-8cc6-c386a3847405">


index로 바꾸어도 안정적이지 않음 왜냐하면 index는 데이터의 추가나 삭제에 의해 변경될 수 있기 때문
<img width="1920" alt="17" src="https://github.com/user-attachments/assets/c766c13b-a0d2-4e35-9831-38470ecd9083">


그렇기 때문에 database에서 가져온 것처럼 안정적인 속성에서 파생된 안정적인 id를 사용해야 함

name은 unique하지 않기 때문에 id로는 적합하지 않음

serialNumber 같은 unique한 id를 사용하는 것이 더 나은 애니메이션과 퍼포먼스를 보장
<img width="1920" alt="18" src="https://github.com/user-attachments/assets/f1916976-7eb5-41b0-98e9-17c474513d9c">
<img width="1920" alt="19" src="https://github.com/user-attachments/assets/50d26b2e-6a55-450e-93d0-ddde528929fb">


## Explicit identity의 주의점

- 계산 속성에서 random identifier(ex: UUID())를 사용할 때는 주의
- 일반적으로 모든 identity는 안정적이기를 원함
- identity는 시간이 지나도 변경되어선 안됨
- 새로운 identity는 새로운 lifetime을 가지는 새로운 item을 보여줌
- identity는 고유해야함 identity를 공유하면 안됨

SwiftUI는 이러한 속성을 사용하여 버그없이 원할하게 실행되도록 함

<img width="500" alt="20" src="https://github.com/user-attachments/assets/624108e2-a3a2-461d-a2c9-f382b6ca9dbb">

# **Structural** Identity 사용 시 고려사항

# **Example of Structural** Identity
<img width="1920" alt="21" src="https://github.com/user-attachments/assets/a2316ce4-46fc-4deb-90bb-5ad6047e54a4">

if 구문을 통해 분기 처리되었기에 content는 구조적으로 각각 다른 id를 가진 2개의 view로 취급함

하지만 단일 id를 가지는 하나의 content로 처리하고 싶다면 ??
<img width="1920" alt="22" src="https://github.com/user-attachments/assets/7a450997-0107-4722-9f0a-9a69835207ea">

modifier 내에서 컨디션에 따라 값을 변경하여 branch를 제거 해줌
<img width="1920" alt="23" src="https://github.com/user-attachments/assets/770b0899-4b7e-420d-8b94-e43125987345">

참고로 결과값이 false면 불투명도가 1이기 때문에 아무 변화도 일어나지 않는데 이러한 modifier을 비활성화 수정자(Insert modifier)라고 부름

SwiftUI의 modifier은 저렴하기 때문에 Inser modifier의 비용은 거의 없다고 봐도 무방함

# **Structural** Identity의 주의점

- branch를 불필요하게 사용하면 성능 저하, 애니메이션 오류, state 손실 등이 발생
- branch 도입 시에는 여러 view를 나타내는지 아니면 단일 view의 다른 state를 나타내는지 것인지 고려
- 단일 view를 나타내는 것이라면 보통은 Insert modifier을 사용하는 것이 더 나음
<img width="500" alt="24" src="https://github.com/user-attachments/assets/89f2ad18-8dc6-4d18-9ae4-380b0c005b14">


# 참고

https://developer.apple.com/videos/play/wwdc2021/10022