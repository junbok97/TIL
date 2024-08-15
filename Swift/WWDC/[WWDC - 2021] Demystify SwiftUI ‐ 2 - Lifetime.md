# 🤔 SwiftUI는 우리의 코드에서 어떤걸 볼까 ?

### **Identity**

-   SwiftUI가 여러번의 업데이트 동안 **요소(element)**가 동일한것인지 다른것인지 **인식(recognize)**하는 방법

### **Lifetime**

-   SwiftUI가 뷰와 데이터의 **존재(existence)**를 시간에 따라 추적하는 방법

### **Dependency**

-   SwiftUI가 인터페이스를 업데이트해야하는 **시기(when)**와 이유**(why)**를 이해하는 방법

이 세 가지 개념을 통해 SwiftUI는 **변경해야할 사항(what needs to change)**, **시기(when)**, **방법(how)** 을 **결정**할 수 있어 결과적으로 동적인 사용자 인터페이스가 화면에 표시

# Lifetime

-   지난번 학습을 통해 SwiftUI가 identity를 사용하여 뷰를 식별하는 방법을 이해
-   이번엔 identity가 뷰와 데이터의 lifetime과 어떻게 연결되는지를 학습

# State(Value)는 identity가 아니다

![1](https://github.com/user-attachments/assets/fafd5fde-f8e9-4f1a-9915-bc46d12221f8)

테세우스라는 이름(identity)을 가진 고양이가 있을 때 상태(State)가 변할 수 있음

시간에 따라 테세우스는 졸고 있을 수도, 깨어 있을 수도 있고, 짜증을 낼 수도있음 (State가 변화)

상태가 변화해도 테세우스는 테세우스임

**Why? State(Value)가 변화하는거지 identity가 변하는 것이 아니기 때문**

**이것이 view의 identity와 lifetime을 연결하는 본질(essence)**

![2](https://github.com/user-attachments/assets/c5e7f1d6-5de5-4ad5-8772-bb4753d8c8f3)

-   테세우스 처럼 view는 **identity가 동일하다면 state(value)가 달라도 동일한 view로 인식**
-   identity를 사용하면 시간에 따라 변화하는 다양한 Value를 안정적으로 정의 가능
    -   연속성을 가진다

# View value ≠ View Identity

![3](https://github.com/user-attachments/assets/5b52e3ca-e21e-4736-b6a9-9180915c75f0)![4](https://github.com/user-attachments/assets/7c8406fc-4d07-4ac5-a1e1-ce8f89ce3fce)

처음 body가 실행되어 `PurrDecibelView(intensity: 25)` 가 생성되고 나중에 `PurrDecibelView(intensity: 50)` 이 생성되면 SwiftUI는 뷰가 변경되었는지 비교하기 위해 값의 복사본을 유지한 뒤 비교한 후에 소멸 시킴

![5](https://github.com/user-attachments/assets/8c698b5a-41bf-407d-bea5-6aa7c22ced86)

여기서 주목해야할 점은 view value와 view identity는 다르다는 것

view value는 일시적이기 때문에 view lifetime에 의존해선 안됨

하지만 identity는 컨트롤 가능함 How?

# A view’s lifetime is the duration of the identity

![6](https://github.com/user-attachments/assets/897bfd7d-a1eb-444a-b1b3-dd06ed45883b)

view가 처음 생성되고 onAppear될때 SwiftUI는 identity를 할당 (Explicit or Structural)

시간에 따라 view에 새로운 value들이 생성될 수 있지만(state의 변경) identity는 동일하기 때문에 SwiftUI는 동일한 view로 인식

view의 lifetime이 종료될때는 identity가 바뀌거나 view가 제거될 때

결과적으로 view의 lifetime은 view의 identity 지속시간이 됨

![7](https://github.com/user-attachments/assets/eb996ca4-2663-446f-a6d9-c1f59a7ab5c4)

\# State lifetime = View lifetime

![8](https://github.com/user-attachments/assets/f1b77468-09a2-4b70-95f1-015202325468)![9](https://github.com/user-attachments/assets/2866c88f-e39a-4487-a0ad-203ab71ea4ec)

SwiftUI가 view에서 `@state`, `@stateObject` 를 보면 해당 데이터를 view의 lifetime동안 유지해야한다는것을 인식

즉 `@state`, `@stateObject` 는 view의 identity와 연결된 영구적인 저장소(persistent storage)

view의 ID가 처음 생성될때 SwiftUI는 `@state`, `@stateObject` 의 초기값을 사용하여 메모리에 저장소(storage)를 할당

![10](https://github.com/user-attachments/assets/8dc2609d-d418-4f92-a37c-8c40296e35eb)

`title state` 를 예시로 보면 SwiftUI는 storage가 변경되어 view의 body가 재호출(re-evaluated)되어도 view의 lifetime동안 storage를 유지(persist)

![11](https://github.com/user-attachments/assets/af7057a6-f252-49e6-a95a-65f7f21a7376)

지난 시간 학습을 통해 위 예제 코드에는 두개의 뷰에 다른 Structural Identity가 할당됨

지난번에는 이것이 애니메이션에 어떤 영향을 미치는지에 대해서만 학습했지만 이것은 state 지속성에도 영향을 미침

![12](https://github.com/user-attachments/assets/f895e999-59ab-4b2f-971d-2fd5b4c59a9c)

실제로 body가 처음 동작하게 되면 실제 분기에서 `dayTime` 이 `True` 일때 SwiftUI는 초기값을 사용해 영구 저장소를 할당함

SwiftUI는 view의 lifetime동안 다양한 작업에 의해 state가 바뀌어도 이 저장소를 유지함

![13](https://github.com/user-attachments/assets/3ca48a09-1b37-4cc3-abab-adac301218a5)

하지만 `dayTime` 이 `False` 로 변경되어 분기가 바뀌게 되면 SwiftUI는 다른 identity를 가진 view라고 인식하게 됨

SwiftUI는 다른 view라고 인식했기 때문에 초기값을 사용하여 새로운 영구저장소를 할당하고 기존에 있던 영구 저장소는 할당 취소 됨

![14](https://github.com/user-attachments/assets/35b6b9eb-c308-4deb-9af7-0b133f51ddf4)

하지만 다시 원래 분기로 돌아간다면 ?? 아까와 같은 상황이 발생

다른 identity이므로 초기값을 사용하여 새로운 저장소를 할당하고 기존의 저장소를 해제

즉 identity가 바뀔때마다 state는 대체(replace)된다는 것

![15](https://github.com/user-attachments/assets/97af6b0d-d741-4ccd-a5a7-3f2d9ed21b86)![16](https://github.com/user-attachments/assets/a4c24426-797e-4bae-8408-d94f4cf56eb9)

identity가 변경되면 state(storage)가 교체(replaced)

identity는 view의 lifetime에 연관되어 있기 때문에

state의 persistence는 view의 lifetime와 연관이 있다는 것

![17](https://github.com/user-attachments/assets/dcd21a86-68ca-451f-9bc7-681598d09cdc)

# Lifetime

-   view value는 일시적이기 때문에 view value의 lifetime에 의존하면 안됨
-   view의 lifetime이 view의 identity의 지속시간임
-   view의 identity를 제어할 수 있기 때문에 identity를 사용하여 state lifetime의 범위를 명확히 지정 가능
-   SwiftUI는 데이터 기반 components에 대해 `Identifiable` 프로토콜을 최대한 활용하기 때문에 안정적인 identifier를 선택하는것이 매우 중요
-   A view's value is short-lived
-   A view's lifetime is the duration of its identity
-   Persistence of state is tied to lifetime
-   Provide a stable identity for your data

# 참고

[https://developer.apple.com/videos/play/wwdc2021/10022](https://developer.apple.com/videos/play/wwdc2021/10022)