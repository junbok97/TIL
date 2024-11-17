# Configurations 사용시 주의점

모듈화시 각 모듈에서 사용하는 ThirdParty Library들의 효율적인 관리를 위해 ThirdPartyKit이라는 모듈로 분리하여 사용하였다.

<img width="1624" alt="1" src="https://github.com/user-attachments/assets/75895744-e221-4ae3-956c-9daf03760dc8">
<img width="1624" alt="2" src="https://github.com/user-attachments/assets/df1dd9b6-379f-4848-9bc7-92bbc7b9d30c">
<img width="1624" alt="3" src="https://github.com/user-attachments/assets/9f2e5dd5-d132-4203-8632-fc392ffe34ae">


App 테스트를 위해 Configurations를 각각 다르게 줘고 Scheme를 각각 설정하였다.

Dev, QA, Release Scheme이다

<img width="1624" alt="4" src="https://github.com/user-attachments/assets/c7372638-ca04-4855-84d8-9747eb10b1cd">
<img width="1624" alt="5" src="https://github.com/user-attachments/assets/27bbdbe4-b175-419c-8e9f-9f15a7609881">
<img width="1624" alt="6" src="https://github.com/user-attachments/assets/da572b80-a138-470f-8747-c3ce90844d53">
<img width="1624" alt="7" src="https://github.com/user-attachments/assets/866ae549-0cc9-4dfe-9414-1665f3f1a90f">


App-Release 스키마와 App-Dev 스키마는 정상적으로 실행되는데 App-QA 스키마는 아래와 같은 에러가 발생한다.

```swift
Framework 'ThirdPartyKit' not found
Linker command failed with exit code 1 (use -v to see invocation)
```

~/DerivedData/프로젝트이름/Build/Products의 폴더를 들어가 각각의 폴더를 확인해보면 

QA에만 ThirdPartyKit.framework만 포함되어 있지 않고 있다.

하지만 ThirdPartyKit에 추가한 라이브러리들(SnapKit)은 다 포함되어있다



<img width="1032" alt="8" src="https://github.com/user-attachments/assets/b597c319-4091-441d-99cb-217684f7ce8b">
<img width="1032" alt="9" src="https://github.com/user-attachments/assets/e063d2c0-baa3-4483-a51a-9347507441b6">
<img width="1032" alt="10" src="https://github.com/user-attachments/assets/e8f04af4-4d3b-4e7b-b3e5-c33d5147de43">
<img width="1032" alt="11" src="https://github.com/user-attachments/assets/cb36e17e-a6af-4f77-bbdc-f60f1c823553">

ThirdPartyKit.framework가 포함되지 않는 이유는 ThirdPartyKit의 Configurations와 App의 Configurations가 일치하지 않기 때문이다.

<img width="1624" alt="12" src="https://github.com/user-attachments/assets/5d351f8f-8e99-4d83-b663-67aedc58bf54">
<img width="1624" alt="13" src="https://github.com/user-attachments/assets/fb7bbab2-55a0-4bc6-a1c1-3fa6c5e299cd">
<img width="1624" alt="14" src="https://github.com/user-attachments/assets/f48dccd7-8213-421d-b537-8a9c1668ace7">
<img width="1032" alt="15" src="https://github.com/user-attachments/assets/5c2b2d82-7b62-43be-b821-b91c062e1903">

당연하게도 Configurations의 Name은 일치해야 하고

<img width="1624" alt="16" src="https://github.com/user-attachments/assets/31c8830f-7153-4f35-ad7d-7e4c6764d766">


App에 Configurations을 추가할 경우 참조하고 있는 모든 framework의 Configurations를 App과 맞춰줘야 한다.

App에 AnotherFramework 추가

AnotherFramework에 QA Configurations를 추가하기 전 App Build Fail
<img width="1624" alt="17" src="https://github.com/user-attachments/assets/6f3c43c2-d0df-4406-a4f1-98a17c01a6be">
<img width="1624" alt="18" src="https://github.com/user-attachments/assets/aafa4508-e944-4da5-b14b-6f93a7b2b12b">


AnotherFramework에 QA Configurations를 추가한 후 App Build Success
<img width="1624" alt="19" src="https://github.com/user-attachments/assets/a9c1d680-ad6c-4c5e-bcf9-a1019c735d73">